#include "Assets.h"

#include <string>
#include <iomanip>  // for std::setw / std::setfill
#include <sstream>


bool Assets::Init()
{
	PreloadTextures();
#ifdef EMSCRIPTEN
	PreloadAnimations();
#endif
	PreloadImages();
	PreloadFonts();
	PreloadSounds();
	PreloadMusic();

	return true;
}

bool Assets::Deinit()
{
	UnloadTextures();
	UnloadAnimations();
	UnloadImages();
	UnloadFonts();
	UnloadSounds();
	UnloadMusic();

	return true;
}

void Assets::LoadTextureID(const std::string& imageID, const std::string& filePath)
{
	if (!HasTextureID(imageID))
	{
		//Image img = LoadImage(filePath.c_str());
		//if (img.data == NULL) 
		//	std::cout << "Failed to load!" << std::endl;
		//else 
		//{
		//	ImageFormat(&img, PIXELFORMAT_UNCOMPRESSED_R8G8B8A8);
		//	Texture2D textureRef = LoadTextureFromImage(img);
		//	Textures[imageID] = textureRef;
		//}

		const Texture2D textureRef = LoadTexture(filePath.c_str());
		SetTextureFilter(textureRef, TEXTURE_FILTER_BILINEAR);
		Textures[imageID] = textureRef;
	}
}

bool Assets::HasTextureID(const std::string& imageID)
{
	return Textures.contains(imageID);
}

void Assets::UnloadTextureID(const std::string& imageID)
{
	auto it = Textures.find(imageID);
	if (it != Textures.end())
	{
		Textures.erase(it);
	}
}

bool Assets::HasSoundID(const std::string& soundID)
{
	return Sounds.contains(soundID);
}

bool Assets::HasMusicID(const std::string& musicID)
{
	return Musics.contains(musicID);
}

void Assets::PreloadTextures()
{
	//const auto Load = [&](const std::string Name, const char* FileName)
	//	{
	//		const Texture2D Sprite = LoadTexture(FileName);
	//		Textures[Name] = Sprite;
	//	};

	//Load("Sprites", "Data/Sprites/VisualSprites.png");

	LoadTextureID("MA", "data/bibata_A.png");
	LoadTextureID("MB", "data/bibata_B.png");
	LoadTextureID("Shade", "data/Images/t.png");
	//LoadTextureID("MansionDay", "data/Scenes/Mansion_Day.png");
	//LoadTextureID("MansionNight", "data/Scenes/Mansion_Night.png");
}

void Assets::UnloadTextures()
{
	for (auto sprite : Textures)
	{
		UnloadTexture(GetTexture(sprite.first));
	}
}

void Assets::PreloadImages()
{
	const auto Load = [&](const std::string Name, const char* FileName)
	{
		const Image Image = LoadImage(FileName);
		Images[Name] = Image;
	};
}

void Assets::UnloadImages()
{
	for (auto image : Images)
	{
		UnloadImage(GetImage(image.first));
	}
}

void Assets::PreloadAnimations()
{
	//const auto Load = [&](const std::string Name, const char* FileName)
	//{
	//	int totalFrameCount = 1;
	//	const Image Image = LoadImageAnim(FileName, &totalFrameCount);
	//	Images[Name] = Image;
	//	AnimFrames[Name] = totalFrameCount;
	//};

	PreloadRoadIntroAnimation();

	PreloadMansionIntroAnimation();
}

void Assets::PreloadRoadIntroAnimation()
{
	for (int i = 0; i <= 133; i++)
	{
		// Build filename: frame_0001.jpg
		std::ostringstream ss;
		ss << "data/Intro/NightDrive/NightDrive" << std::setw(4) << std::setfill('0') << i << ".jpg";
		std::string filename = ss.str();
		NightDriveFrames.push_back(LoadTexture(filename.c_str()));
	}
}

void Assets::PreloadMansionIntroAnimation()
{
	for (int i = 0; i <= 117; i++)
	{
		std::ostringstream ss;
		ss << "data/Intro/Mansion/Mansion" << std::setw(4) << std::setfill('0') << i << ".jpg";
		std::string filename = ss.str();
		MansionFrames.push_back(LoadTexture(filename.c_str()));
	}
}

void Assets::UnloadAnimations()
{
	for (auto& item : NightDriveFrames)
	{
		UnloadTexture(item);
	}

	for (auto& item : MansionFrames)
	{
		UnloadTexture(item);
	}

	NightDriveFrames.clear();
	MansionFrames.clear();
}


void Assets::PreloadFonts()
{
	const auto Load = [&](const std::string Name, const char* FileName, const int size = 0)
		{
			const Font Font = (size == 0) ? LoadFont(FileName) : LoadFontEx(FileName, 64, 0, 0);
			Fonts[Name] = Font;
			SetTextureFilter(Font.texture, TEXTURE_FILTER_BILINEAR);
		};

	Load("Gothic", "data/Franklin-Gothic-Heavy-Italic.ttf", 64);
	Load("Noto", "data/NotoSansUI-Regular.ttf");

	//Load("NotoBold", "Data/NotoSans-Bold.ttf");
	//Load("NotoBoldItalic", "Data/NotoSans-BoldItalic.ttf");
	//Load("NotoItalic", "Data/NotoSans-Italic.ttf");
}

void Assets::UnloadFonts()
{
	for (auto font : Fonts)
	{
		UnloadFont(GetFont(font.first));
	}
}

void Assets::PreloadSounds()
{
	const auto Load = [&](const std::string Name, const char* FileName)
		{
			const Sound Sound = LoadSound(FileName);
			Sounds[Name] = Sound;
		};

	//Load("Fire", "Data/Sound/MiniGun_A.wav");

	Load("Thunderbolt", "Data/Sound/Thunderbolt.mp3");
	Load("Bang", "Data/Sound/Sonorous_Bang.mp3");
	Load("Storm", "Data/Sound/Storm_Roar.mp3");
	Load("Rumble", "Data/Sound/Heavy_Rumble.mp3");
	Load("Thunder", "Data/Sound/Crumbling_Thunder.mp3");
}

void Assets::UnloadSounds()
{
	//UnloadSound(GetSound("Fire"));
	for (auto sound : Sounds)
	{
		UnloadSound(GetSound(sound.first));
	}
}

void Assets::PreloadMusic()
{
	const auto Load = [&](const std::string Name, const char* FileName, bool loop = true)
		{
			const Music Music = LoadMusicStream(FileName);
			Musics[Name] = Music;
		};
	
	//Load("FireLoop", "Data/Sound/stg_st003_88pro-loop.ogg", false);
}

void Assets::UnloadMusic()
{
	//UnloadMusicStream(GetMusic("Menu"));
	for (auto music : Musics)
	{
		UnloadMusicStream(GetMusic(music.first));
	}
}

