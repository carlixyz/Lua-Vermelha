return {

    { Quad = (function() 
        local self = { }
        function self.OnConstruct() return { Clickable = true, NameId = "FamilyPhotoExit", Cursor = "MDown",
            Pos = { x = 0, y = 350 }, Size = { Width = 920, Height = 160 }} end
        function self.OnInteract()
            BlendScene("Fireplace", 1) 
        end 
        return self
    end)()
    },  -- SCENE EXIT

    { Entity = "PhotoCloseup", Visible = true, Textures =
        { { FPhoto = "data/Scenes/Mansion/FamilyPhoto.jpg" }, 
        { FPhotoA = "data/Scenes/Mansion/FamilyPhotoAda.jpg" }, 
        { FPhotoR = "data/Scenes/Mansion/FamilyPhotoRegina.jpg" }, 
        { FPhotoI = "data/Scenes/Mansion/FamilyPhotoIlsa.jpg" }, 
        { FPhotoV = "data/Scenes/Mansion/FamilyPhotoVik.jpg" }, 
        { FPhotoAll = "data/Scenes/Mansion/FamilyPhotoAll.jpg" } }
    } -- PICTURE CLOSEUP


}