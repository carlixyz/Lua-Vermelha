#pragma once

#include "../Utility/Singleton.h"
#include <iostream>
#include <raylib-cpp.hpp>
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

	void LoadTextureID(const std::string& imageID, const std::string& filePath);

	bool HasTextureID(const std::string& imageID);

	void UnloadTextureID(const std::string& imageID);


	Texture2D GetTexture(const std::string& NameID) { return Textures[NameID]; }

	Image GetImage(const std::string& NameID) { return Images[NameID]; }

	Font GetFont(const std::string& NameID) { return Fonts[NameID]; }

	Sound GetSound(const std::string& NameID) { return Sounds[NameID]; }

	Music GetMusic(const std::string& NameID) { return Musics[NameID]; }

	std::vector<Texture2D>& MansionIntro() { return MansionFrames; }

	std::vector<Texture2D>& NightDriveIntro() { return NightDriveFrames; }


private:
	void PreloadTextures();
	void UnloadTextures();

	void PreloadImages();
	void UnloadImages();

	void PreloadAnimations();
	void UnloadAnimations();

	void PreloadFonts();
	void UnloadFonts();

	void PreloadSounds();
	void UnloadSounds();

	void PreloadMusic();
	void UnloadMusic();
};


#define GetTexture( NameID ) Assets::Get().GetTexture( NameID )
#define GetImage( NameID ) Assets::Get().GetImage( NameID )
#define GetFramesCount( NameID ) Assets::Get().GetAnimFrames( NameID )
#define GetFont( NameID ) Assets::Get().GetFont( NameID )
#define GetMusic( NameID ) Assets::Get().GetMusic( NameID )
#define GetSound( NameID ) Assets::Get().GetSound( NameID )
//#define Stringify(name) #name

//#define ASSETS Assets::Get()
//#define GetAsset(NameID) ASSETS.GetSprite(#NameID)