#include <raylib-cpp.hpp>

#include <vector>


struct PixelBuffer
{
	std::vector<Color> Buffer;
	int Width;
	int Height;
	int Area;
	Texture2D* Textured = nullptr;

	PixelBuffer() : Width(1), Height(1), Area(1) {}

	PixelBuffer(int width, int height) : 
		Width(width), 
		Height(height), 
		Area(width*height)
	{
		Buffer.resize(Area);
	}

	void LoadFromImage(const Image& img)
	{
		Resize(img.width, img.height);

		if (Color* imgColors = LoadImageColors(img))
		{
			// Copy raw memory into our std::vector
			std::copy(imgColors, imgColors + Area, Buffer.begin());
		}
	}

	inline void Resize(int width, int height)
	{
		Width = width;
		Height = height;
		Area = Width * Height;
		Buffer.resize(Area);
	}

	inline void SetPixel(int x, int y, Color inColor)
	{
		if (x < 0 || y < 0 || x >= Width || y >= Height)
			return;
		Buffer[y * Width + x] = inColor;
	}

	Color& operator[](int index)
	{
		return Buffer[index];
	}

	PixelBuffer& operator=(const PixelBuffer& b)
	{
		Width = b.Width;
		Height = b.Height;
		Area = Width * Height;
		Buffer = b.Buffer;
		return *this;
	}

	inline void Cls(Color inColor = BLACK)	// Clear Screen to black
	{
		std::fill(Buffer.begin(), Buffer.end(), inColor);
	}

	inline bool onArea(int x, int y)
	{
		return (x >= 0 && y >= 0 && x < Width && y < Height);
	}


	inline int Clamp(int n, int lower, int upper)
	{
		return n + ((n < lower) * (lower - n)) + ((n > upper) * (upper - n));
	}

	inline void Copy(const Image& src, int xCoord = 0, int yCoord = 0)			// Copy from Another buffer Data Inside 
	{
		Color* pixels = (Color*)src.data;

		for (int x = 0, pixX = 0; x < src.width; x++)
			for (int y = 0, pixY = 0; y < src.height; y++)
			{
				pixX = (x + xCoord);
				pixY = (y + yCoord) * this->Width;
				if (pixY + pixX >= this->Area)
					continue;

				Color& pixel = pixels[src.width * y + x];

				if (pixel.a < 1.0f)
					continue;

				Buffer[pixY + pixX] = pixel; //Add
			}
	}

	inline void Copy(PixelBuffer& src, int xCoord = 0, int yCoord = 0)			// Draw Another buffer Data Inside 
	{
		for (int x = 0, pixX = 0; x < src.Width; x++)
			for (int y = 0, pixY = 0; y < src.Height; y++)
			{
				pixX = (x + xCoord);
				pixY = (y + yCoord) * this->Width;
				if (pixY + pixX >= this->Area)
					continue;

				Color& pixel = src[src.Width * y + x];

				if (pixel.a < 1.0f)
					continue;

				Buffer[pixY + pixX] = pixel; //Add
			}
	}

	void CopyX2(PixelBuffer& source) // Take a source buffer & duplicates its size in windows
	{
		Resize(source.Width * 2, source.Height * 2);

		int HalfWidth = source.Width;
		int HalfHeight = source.Height;

		Color* dp = this->Buffer.data();
		Color* sp = source.Buffer.data();

		for (int y = 0; y < HalfHeight; y++)
		{
			Color* rowStart = sp; // keep a pointer to start of this row

			// First copy (duplicate horizontally)
			for (int x = 0; x < HalfWidth; x++) {
				Color c = *sp++;   // load once
				dp[0] = c;         // write twice
				dp[1] = c;
				dp += 2;
			}

			// Second copy (duplicate the same row again)
			sp = rowStart;         // reset to row start
			for (int x = 0; x < HalfWidth; x++) {
				Color c = *sp++;   // load once
				dp[0] = c;
				dp[1] = c;
				dp += 2;
			}
		}
	}

	inline void ReScale(float factor)											// Scaling Property
	{
		PixelBuffer refBuffer(Width, Height);									// TempCopy
		refBuffer.Buffer = this->Buffer;

		this->Resize((int)(Width * factor), (int)(Height * factor));			// Real Buffer Resize

		float scaleWidth = (float)this->Width / (float)refBuffer.Width;			// Scale proportion
		float scaleHeight = (float)this->Height / (float)refBuffer.Height;

		for (int cy = 0; cy < this->Height; cy++)
		{
			for (int cx = 0; cx < this->Width; cx++)
			{
				int pixel = (cy * (this->Width)) + (cx);
				int nearestMatch = (((int)(cy / scaleHeight) * (refBuffer.Width)) + ((int)(cx / scaleWidth)));
				Buffer[pixel] = refBuffer.Buffer[nearestMatch];
			}
		}
	}


	/// Draw directly to the screen (Too espensive use a texture like Draw below instead)
	///  UpdateTextureRec(	bufferTex,	Rectangle{ 0, 0, (float)this.Width, (float)this.Height }, this.Buffer.data());
	///  DrawTexturePro(	bufferTex,	Rectangle{ 0, 0, (float)Pixels.Width, (float)Pixels.Height },
    ///									Rectangle{ 0, 0, (float)GetScreenWidth(), (float)GetScreenHeight()},
    ///									Vector2::Zero(), 0.0f, WHITE);
	/*
	void Draw(int xCoord = 0, int yCoord = 0, int scale = 1)
	{
		for (int x = 0, pixX = 0; x < Width; x++)
			for (int y = 0, pixY = 0; y < Height; y++)
			{
				pixX = (x + xCoord);
				pixY = (y + yCoord) * this->Width;
				if (pixY + pixX >= this->Area)
					continue;

				Color& pixel = Buffer[Width * y + x];

				if (pixel.a <= .25f)
					continue; // skip fully transparent

				if (scale == 1) 
					DrawPixel(xCoord + x, yCoord + y, pixel);
				else 
					DrawRectangle(xCoord + x * scale, yCoord + y * scale,
						scale, scale, pixel);
			}
	}
	*/

	void Draw(int scale = 1, int xCoord = 0, int yCoord = 0)
	{
		if (!Textured)
		{
			Textured = new Texture2D();
			Image img = {
				.data = Buffer.data(),
				.width = Width,
				.height = Height,
				.mipmaps = 1,
				.format = PIXELFORMAT_UNCOMPRESSED_R8G8B8A8
						};

			*Textured = LoadTextureFromImage(img);
		}
		
		UpdateTextureRec(*Textured, Rectangle{ 0, 0, (float)Width, (float)Height }, Buffer.data());
		DrawTextureEx(*Textured, { (float)xCoord, (float)yCoord }, 0.0f, (float)scale, WHITE);
	}

	~PixelBuffer()
	{
		if (Textured != nullptr)
		{
			UnloadTexture(*Textured);
			delete Textured;
			Textured = nullptr;
		}
	}
};
