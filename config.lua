local _, settings = ...

local config = {
	barTexture = [=[Interface\AddOns\oUF_Gdx\media\statusbar]=],
	backdropEdge = [=[Interface\Addons\oUF_Gdx\media\backdropedge]=],
	backdropFill = [=[Interface\ChatFrame\ChatFrameBackground]=],
	buttonTex = [=[Interface\Addons\oUF_Gdx\media\buttonoverlay]=],
	font = [=[Interface\Addons\oUF_Gdx\Russel Square LT.ttf]=],
	aurafont = [=[Interface\Addons\oUF_Gdx\media\squares.ttf]=],
	symbolfont = [=[Interface\Addons\oUF_Gdx\media\PIZZADUDEBULLETS.ttf]=],
	
	["player"] = {
		Dimensions = {
			Width = 230,
			Height = 55,
			Reverse = false,
		},
		Health = {
			Size = 27,
			Value = {
				Point = {
					"BOTTOMRIGHT",
					"BOTTOMRIGHT",
					-5,
					5,
				},
				Justify = "RIGHT",
			},
			Smooth = true,
		},
		Power = {
			Size = 8,
			Value = {
				Point = {
					"BOTTOMLEFT",
					"BOTTOMLEFT",
					5,
					5,
				},
				Justify = "LEFT",
			},
		},
		Castbar = {
			Size = 18,
			Icon = {
				"TOPRIGHT",
				"LEFT",
				-10,
				10,
			},
		},
		Enchant = {
			Size = 26.5,
			Point = {
				"TOPRIGHT",
				"TOPLEFT",
				-3,
				0,
			},
			Anchor = "TOPRIGHT",
			GrowthY = "DOWN",
			Spacing = 2,
		},
		Experience = {
			Size = 18,
		},
		Buffs = {
			Size = 27,
			Point = {
				"BOTTOMLEFT",
				"TOPLEFT",
				0,
				3,
			},
			Anchor = "BOTTOMLEFT",
			GrowthY = "UP",
			GrowthX = "RIGHT",
			num = 24,
			Spacing = 2,
		},
		Debuffs = {
			Size = 27,
			Point = {
				"BOTTOMRIGHT",
				"TOPRIGHT",
				0,
				3,
			},
			Anchor = "BOTTOMRIGHT",
			GrowthY = "UP",
			GrowthX = "LEFT",
			num = 8,
			Spacing = 2,
		},
		Panel = {
			Size = 20,
			
			DPS = {
				Point = {
					"BOTTOM",
					"BOTTOM",
					0,
					5,
				},
			},
		},
		Combat = {
			Size = 32,
			Point = {
				"CENTER",
				"CENTER",
				0,
				15,
			},
		},
		Leader = {
			Size = 16,
			Point = {
				"CENTER",
				"TOPLEFT",
				0,
				0,
			},
		},
		MasterLooter = {
			Size = 16,
			Point = {
				"CENTER",
				"TOPLEFT",
				16,
				0,
			},
		},
		Threat = true,
	},
	
	["pet"] = {
		Dimensions = {
			Width = 115,
			Height = 35,
			Reverse = false,
		},
		Health = {
			Size = 18,
			Smooth = true,
		},
		Panel = {
			Size = 17,
			
			Info = {
				Point = {
					"BOTTOM",
					"BOTTOM",
					0,
					3.5,
				},
				Tag = "[GetNameColor][NameLong] [DiffColor][level] [shortclassification]",
			},
		},
		Experience = {
			Size = 18,
		},
		Debuffs = {
			Size = 27,
			Point = {
				"BOTTOMLEFT",
				"TOPLEFT",
				0,
				3,
			},
			Anchor = "BOTTOMLEFT",
			GrowthY = "UP",
			GrowthX = "RIGHT",
			num = 4,
			Spacing = 2,
		},
	},
	
	["target"] = {
		Dimensions = {
			Width = 230,
			Height = 55,
			Reverse = true,
		},
		Health = {
			Size = 27,
			Value = {
				Point = {
					"BOTTOMLEFT",
					"BOTTOMLEFT",
					5,
					5,
				},
				Justify = "LEFT",
			},
			Smooth = true,
		},
		Power = {
			Size = 8,
			Value = {
				Point = {
					"BOTTOMRIGHT",
					"BOTTOMRIGHT",
					-5,
					5,
				},
				Justify = "RIGHT",
			},
		},
		Castbar = {
			Size = 18,
			Icon = {
				"TOPLEFT",
				"RIGHT",
				10,
				10,
			},
		},
		Buffs = {
			Size = 27,
			Point = {
				"BOTTOMRIGHT",
				"TOPRIGHT",
				0,
				3,
			},
			Anchor = "BOTTOMRIGHT",
			GrowthY = "UP",
			GrowthX = "LEFT",
			num = 8,
			Spacing = 2,
		},
		Debuffs = {
			Size = 27,
			Point = {
				"BOTTOMLEFT",
				"TOPLEFT",
				0,
				3,
			},
			Anchor = "BOTTOMLEFT",
			GrowthY = "UP",
			GrowthX = "RIGHT",
			num = 24,
			Spacing = 2,
		},
		Panel = {
			Size = 20,
			
			Info = {
				Point = {
					"BOTTOM",
					"BOTTOM",
					0,
					5,
				},
				Tag = "[GetNameColor][NameLong] [DiffColor][level] [shortclassification]",
			},
		},
		Leader = {
			Size = 16,
			Point = {
				"CENTER",
				"TOPRIGHT",
				0,
				0,
			},
		},
		MasterLooter = {
			Size = 16,
			Point = {
				"CENTER",
				"TOPRIGHT",
				-16,
				0,
			},
		},
	},
	
	["targettarget"] = {
		Dimensions = {
			Width = 115,
			Height = 35,
			Reverse = true,
		},
		Health = {
			Size = 18,
			Smooth = true,
		},
		Panel = {
			Size = 17,
			Info = {
				Point = {
					"BOTTOM",
					"BOTTOM",
					0,
					3.5,
				},
				Tag = "[GetNameColor][NameMedium]",
			},
		},
		Debuffs = {
			Size = 27,
			Point = {
				"BOTTOMRIGHT",
				"TOPRIGHT",
				0,
				3,
			},
			Anchor = "BOTTOMRIGHT",
			GrowthY = "UP",
			GrowthX = "LEFT",
			num = 4,
			Spacing = 2,
		},
	},
	
	["focus"] = {
		Dimensions = {
			Width = 115,
			Height = 35,
			Reverse = true,
		},
		Health = {
			Size = 16,
			Smooth = true,
		},
		Power = {
			Size = 2,
		},
		Panel = {
			Size = 17,
			Info = {
				Point = {
					"BOTTOM",
					"BOTTOM",
					0,
					3.5,
				},
				Tag = "[GetNameColor][NameMedium]",
			},
		},
		Castbar = {
			Size = 18,
			Icon = {
				"TOPLEFT",
				"RIGHT",
				10,
				10,
			},
		},
	},
	
	["raid"] = {
		Dimensions = {
			Width = 45,
			Height = 35,
			Reverse = false,
		},
		Health = {
			Orientation = "VERTICAL",
			Size = 35,
			HealComm = true,
			ResComm = true,
		},
		RaidInfo = {
			Point = {
				"CENTER",
				"CENTER",
				0,
				0,
			},
			Tag = "[GetNameColor][RaidHP]",
			Justify = "CENTER",
		},
		Leader = {
			Size = 8,
			Point = {
				"CENTER",
				"TOPLEFT",
				0,
				0,
			},
		},
		MasterLooter = {
			Size = 8,
			Point = {
				"CENTER",
				"TOPLEFT",
				8,
				0,
			},
		},
		LFDRole = {
			Size = 12,
			Point = {
				"CENTER",
				"TOPRIGHT",
				0,
				0,
			},
		},
		DebuffIcon = true,
		Status = true,
		Threat = true,
	},
	
	["boss"] = {
		Dimensions = {
			Width = 230,
			Height = 55,
			Reverse = false,
		},
		Health = {
			Size = 27,
			Value = {
				Point = {
					"BOTTOMRIGHT",
					"BOTTOMRIGHT",
					-5,
					5,
				},
				Justify = "RIGHT",
			},
			Smooth = true,
		},
		Power = {
			Size = 8,
			Value = {
				Point = {
					"BOTTOMLEFT",
					"BOTTOMLEFT",
					5,
					5,
				},
				Justify = "LEFT",
			},
		},
		Castbar = {
			Size = 18,
			Icon = {
				"TOPLEFT",
				"RIGHT",
				10,
				10,
			},
		},
		Panel = {
			Size = 20,
			Info = {
				Point = {
					"BOTTOM",
					"BOTTOM",
					0,
					5,
				},
				Tag = "[GetNameColor][NameLong]",
			},
		}
	}
}

if (class == "DEATHKNIGHT") then
	config["player"].Runes = {
		Point = {
			"TOPLEFT",
			"TOPLEFT",
			0,
			0,
		},
		Growth = "RIGHT",
		Anchor = "TOPLEFT",
		Size = 8,
		Spacing = 0,
		Colors = {
			[1] = {.69,.31,.31},
			[2] = {.69,.31,.31},
			[3] = {.33,.59,.33},
			[4] = {.33,.59,.33},
			[5] = {.31,.45,.63},
			[6] = {.31,.45,.63},
		},
	}
end

if (class == "ROGUE" or class == "DRUID") then
	config["target"].Combo = {
		Point = {
			"TOPRIGHT",
			"TOPRIGHT",
			0,
			0,
		},
		Anchor = "TOPRIGHT",
		Size = 8,
	}
end

settings.config = config