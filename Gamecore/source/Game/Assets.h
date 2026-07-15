#pragma once

#include "../Utility/Singleton.h"
#include <iostream>
#include <raylib-cpp.hpp>
#include <map>
#include <unordered_map>
#include <vector>
#include <array>


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


	Texture2D& GetTexture(const std::string& NameID) { return Textures.at(NameID); }

	Texture2D* TryGetTexture(const std::string& NameID) 
	{
		auto it = Textures.find(NameID); 
		return (it != Textures.end()) ? &it->second : nullptr;
	}

	Image GetImage(const std::string& NameID) { return Images.at(NameID); }

	Font& GetFont(const std::string& NameID) { return Fonts.at(NameID); }

	Sound& GetSound(const std::string& NameID) { return Sounds.at(NameID); }

	bool HasSoundID(const std::string& soundID);

	const Music& GetMusic(const std::string& NameID) { return Musics.at(NameID); }

	bool HasMusicID(const std::string& musicID);

	Sound& GetThunderBang();

	Sound& GetThunderClap();

	std::vector<Texture2D>& MansionIntro() { return MansionFrames; }

	std::vector<Texture2D>& NightDriveIntro() { return NightDriveFrames; }

	void PreloadMansionIntroAnimation();

	void PreloadRoadIntroAnimation();


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

	void PreloadThunders();
	void UnloadThunders();

#define MAX_BANGS 12
	//Sound BangsArray[MAX_BANGS] = { 0 };
	std::array<Sound, MAX_BANGS> BangsArray;
	int CurrentBang;


#define MAX_CLAPS 12
	//Sound ClapsArray[MAX_CLAPS] = { 0 };
	std::array<Sound, MAX_CLAPS> ClapsArray;
	int CurrentClap;
};


#define TryGetTexture( NameID ) Assets::Get().TryGetTexture( NameID )
#define GetTexture( NameID ) Assets::Get().GetTexture( NameID )
#define GetImage( NameID ) Assets::Get().GetImage( NameID )
#define GetFramesCount( NameID ) Assets::Get().GetAnimFrames( NameID )
#define GetFont( NameID ) Assets::Get().GetFont( NameID )
#define GetMusic( NameID ) Assets::Get().GetMusic( NameID )
#define GetSound( NameID ) Assets::Get().GetSound( NameID )
//#define Stringify(name) #name

//#define ASSETS Assets::Get()
//#define GetAsset(NameID) ASSETS.GetSprite(#NameID)