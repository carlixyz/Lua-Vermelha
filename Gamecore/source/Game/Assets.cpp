#include "Assets.h"

#include <string>
#include <iomanip>  // for std::setw / std::setfill
#include <sstream>
#include "Game.h"

bool Assets::Init()
{
	PreloadTextures();
#ifdef EMSCRIPTEN
	PreloadAnimations();
#endif
	PreloadImages();
	PreloadFonts();

	if (Game::Get().IsAudioEnabled())
	{
		PreloadSounds();
		PreloadMusic();
		PreloadThunders();
	}

	return true;
}

bool Assets::Deinit()
{
	UnloadTextures();
	UnloadAnimations();
	UnloadImages();
	UnloadFonts();
	UnloadThunders();
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
	LoadTextureID("MUp", "data/bibata_Up.png");
	LoadTextureID("MDown", "data/bibata_Down.png");
	LoadTextureID("MRight", "data/bibata_Right.png");
	LoadTextureID("MLeft", "data/bibata_Left.png");

	LoadTextureID("Shade", "data/Images/t.png");
	LoadTextureID("TDisabled", "data/Images/Thiago/TDisabled.png");

	LoadTextureID("TNeutral", "data/Images/Thiago/TNeutral.png");
	LoadTextureID("TSuspect", "data/Images/Thiago/TSuspect.png");
	LoadTextureID("TThink", "data/Images/Thiago/TThink.png");
	LoadTextureID("TWorry", "data/Images/Thiago/TWorry.png");
	LoadTextureID("TPeace", "data/Images/Thiago/TPeace.png");
	LoadTextureID("TScary", "data/Images/Thiago/TScary.png");

	LoadTextureID("TComplicity", "data/Images/Thiago/TComplicity.png");
	LoadTextureID("TSurprise", "data/Images/Thiago/TSurprise.png");
	LoadTextureID("TSmile", "data/Images/Thiago/TSmile.png");
	LoadTextureID("TLaugh", "data/Images/Thiago/TLaugh.png");
	LoadTextureID("TAngry", "data/Images/Thiago/TAngry.png");

	LoadTextureID("T4Wall", "data/Images/Thiago/T4Wall.png");
	LoadTextureID("TLook", "data/Images/Thiago/TLook.png");
	LoadTextureID("TOof", "data/Images/Thiago/TOof.png");
	LoadTextureID("TSad", "data/Images/Thiago/TSad.png");
	LoadTextureID("TSpy", "data/Images/Thiago/TSpy.png");

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
		UnloadTexture(item);

	for (auto& item : MansionFrames)
		UnloadTexture(item);

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

	Load("Crime", "data/Sound/dark-crime-piano-drama.ogg");
	Load("Viola", "data/Sound/trumpet-piano-viola.ogg");
	Load("CarWarning", "data/Sound/CarWarning.ogg");
	Load("CarDoor", "data/Sound/CarDoor.ogg");
	Load("SeatbeltClick", "data/Sound/SeatbeltClick.ogg");
	Load("SwipeIn", "data/Sound/SwiftIn.ogg");
	Load("SwipeOut", "data/Sound/SwiftOut.ogg");
	Load("Inspection", "data/Sound/Inspection.ogg");

	Load("SwitchOn", "data/Sound/SwitchOn.ogg");
	Load("SwitchOff", "data/Sound/SwitchOff.ogg");
	Load("PianoMi", "data/Sound/piano-mi.ogg");
	Load("LockedDoor", "data/Sound/LockedDoorKnob.ogg");
	Load("OldClock", "data/Sound/OldClock.ogg");
	Load("GlassBreak", "data/Sound/glass-break.ogg");
	Load("WolfStalk", "data/Sound/werewolf-stalks.ogg");
	Load("Suspense", "data/Sound/car-drive-soundfx.ogg");
	Load("TitleFX", "data/Sound/IntroTitle.ogg");


	Load("Bang", "data/Sound/Sonorous_Bang.ogg");
	Load("Storm", "data/Sound/Storm_Roar.ogg");
	Load("Sky", "data/Sound/Sky_Rumble.ogg");
	Load("Crumble", "data/Sound/Crumbling_Thunder.ogg");
	Load("Dry", "data/Sound/ThunderDry.ogg");
	Load("Peals", "data/Sound/ThunderPeals.ogg");

	Load("Rumble", "data/Sound/Heavy_Rumble.ogg");
	Load("Thunderbolt", "data/Sound/Thunderbolt.ogg");
	Load("Thunder", "data/Sound/Rolling_Thunder.ogg");
	Load("Roar", "data/Sound/Heavenly_Roar.ogg");
	Load("Loud", "data/Sound/ThunderLoud.ogg");
	Load("Universal", "data/Sound/ThunderUniversity.ogg");
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
	
	Load("RainDrive", "data/Sound/NightDriveRain.ogg");
	Load("WetAsphalt", "data/Sound/WetAsphaltSymphony.ogg");


	//Load("FireLoop", "data/Sound/stg_st003_88pro-loop.ogg", false);
}

void Assets::UnloadMusic()
{
	//UnloadMusicStream(GetMusic("Menu"));
	for (auto music : Musics)
	{
		UnloadMusicStream(GetMusic(music.first));
	}
}

void Assets::PreloadThunders()
{


	BangsArray = { 
		LoadSoundAlias(GetSound("Bang")), LoadSoundAlias(GetSound("Storm")),
		LoadSoundAlias(GetSound("Sky")), LoadSoundAlias(GetSound("Crumble")),
		LoadSoundAlias(GetSound("Dry")), LoadSoundAlias(GetSound("Peals")),
		LoadSoundAlias(GetSound("Bang")), LoadSoundAlias(GetSound("Storm")),
		LoadSoundAlias(GetSound("Sky")), LoadSoundAlias(GetSound("Crumble")),
		LoadSoundAlias(GetSound("Dry")), LoadSoundAlias(GetSound("Peals"))
	};
	CurrentBang = 0;

	ClapsArray = {
		LoadSoundAlias(GetSound("Rumble")), LoadSoundAlias(GetSound("Thunderbolt")),
		LoadSoundAlias(GetSound("Thunder")), LoadSoundAlias(GetSound("Roar")),
		LoadSoundAlias(GetSound("Loud")), LoadSoundAlias(GetSound("Universal")),
		LoadSoundAlias(GetSound("Rumble")), LoadSoundAlias(GetSound("Thunderbolt")),
		LoadSoundAlias(GetSound("Thunder")), LoadSoundAlias(GetSound("Roar")),
		LoadSoundAlias(GetSound("Loud")), LoadSoundAlias(GetSound("Universal"))
	};
	CurrentClap = 0;
}

void Assets::UnloadThunders()
{
	for (auto& b : BangsArray)
		UnloadSoundAlias(b);     // Unload sound aliases

	for (auto& c : ClapsArray)
		UnloadSoundAlias(c);     // Unload sound aliases
}


Sound& Assets::GetThunderBang()
{

	//::PlaySound(BangsArray[CurrentBang]);			// play the next open sound slot

	CurrentBang++;									// increment the sound slot
	CurrentBang %= MAX_BANGS;						// if the sound slot is out of bounds, go back to 0.

	return BangsArray[CurrentBang];
}

Sound& Assets::GetThunderClap()
{
	//::PlaySound(ClapsArray[CurrentClap]);			// play the next open sound slot

	CurrentClap++;									// increment the sound slot
	CurrentClap %= MAX_CLAPS;						// if the sound slot is out of bounds, go back to 0.

	return ClapsArray[CurrentClap];
}

