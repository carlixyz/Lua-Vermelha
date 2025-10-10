#include "Assets.h"

#include <string>
#include <iomanip>  // for std::setw / std::setfill
#include <sstream>


bool Assets::Init()
{
	PreloadTextures();
	//PreloadAnimations();
	PreloadImages();
	PreloadFonts();
	PreloadSounds();
	PreloadMusic();

	return true;
}

bool Assets::Deinit()
{
	UnloadTextures();
	//UnloadAnimations();
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
		const Texture2D textureRef = LoadTexture(filePath.c_str());
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

void Assets::PreloadTextures()
{
	//const auto Load = [&](const std::string Name, const char* FileName)
	//	{
	//		const Texture2D Sprite = LoadTexture(FileName);
	//		Textures[Name] = Sprite;
	//	};

	//Load("Sprites", "Data/Sprites/VisualSprites.png");
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

	//Load( "NightDrive", "data/NightDriveIntro_3.gif");
	//Load( "NightMansion", "data/Mansion_4.gif");

	for (int i = 0; i <= 133; i++)
	{
		// Build filename: frame_0001.jpg
		std::ostringstream ss;
		ss <<"data/Intro/NightDrive/NightDrive" << std::setw(4) << std::setfill('0') << i << ".jpg";
		std::string filename = ss.str();
		NightDriveFrames.push_back(LoadTexture(filename.c_str()));
	}

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
	const auto Load = [&](const std::string Name, const char* FileName)
		{
			const Font Font = LoadFont(FileName);
			Fonts[Name] = Font;
		};
	//Load("PC98", "Data/pc-9800.ttf");
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

