#pragma once

#include "../Utility/Singleton.h"
#include <iostream>
#include <raylib.h>
#include <map>
#include <vector>



class Assets : public Singleton<Assets>
{
	friend class Singleton<Assets>;

	std::map<std::string, Texture2D> Textures;
	std::map<std::string, Image> Images;
	std::map<std::string, Font> Fonts;
	std::map<std::string, Sound> Sounds;
	std::map<std::string, Music> Musics;

	std::vector<Texture2D> MansionFrames;
	std::vector<Texture2D> NightDriveFrames;


public:
	bool Init();
	bool Deinit();

	Texture2D GetTexture(const std::string& Name)
	{
		return Textures[Name];
	}

	Image GetImage(const std::string& Name)
	{
		return Images[Name];
	}

	Font GetFont(const std::string& Name)
	{
		return Fonts[Name];
	}

	Sound GetSound(const std::string& Name)
	{
		return Sounds[Name];
	}

	Music GetMusic(const std::string& Name)
	{
		return Musics[Name];
	}

	std::vector<Texture2D>& MansionIntro()
	{
		return MansionFrames;
	}

	std::vector<Texture2D>& NightDriveIntro()
	{
		return NightDriveFrames;
	}


private:
	void LoadTextures();
	void UnloadTextures();

	void LoadImages();
	void UnloadImages();

	void LoadAnimations();
	void UnloadAnimations();

	void LoadFonts();
	void UnloadFonts();

	void LoadSounds();
	void UnloadSounds();

	void LoadMusic();
	void UnloadMusic();
};


#define GetTexture( Name ) Assets::Get().GetTexture( Name )
#define GetImage( Name ) Assets::Get().GetImage( Name )
#define GetFramesCount( Name ) Assets::Get().GetAnimFrames( Name )
#define GetFont( Name ) Assets::Get().GetFont( Name )
#define GetMusic( Name ) Assets::Get().GetMusic( Name )
#define GetSound( Name ) Assets::Get().GetSound( Name )
//#define Stringify(name) #name
//
//#define ASSETS Assets::Get()
//#define GetAsset(Name) ASSETS.GetSprite(#Name)