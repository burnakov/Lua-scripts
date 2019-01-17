local Flags = {
	[0x00000000] = 'None',
	[0x00000001] = 'Background',
	[0x00000002] = 'Weapon',
	[0x00000004] = 'Transparent',
	[0x00000008] = 'Translucent',
	[0x00000010] = 'Wall',
	[0x00000020] = 'Damaging',
	[0x00000040] = 'Impassable',
	[0x00000080] = 'Wet',
	[0x00000100] = 'Unknown1',
	[0x00000200] = 'Surface',
	[0x00000400] = 'Bridge',
	[0x00000800] = 'Generic',
	[0x00001000] = 'Window',
	[0x00002000] = 'NoShoot',
	[0x00004000] = 'ArticleA',
	[0x00008000] = 'ArticleAn',
	[0x00010000] = 'Internal',
	[0x00020000] = 'Foliage',
	[0x00040000] = 'PartialHue',
	[0x00080000] = 'Unknown2',
	[0x00100000] = 'Map',
	[0x00200000] = 'Container',
	[0x00400000] = 'Wearable',
	[0x00800000] = 'LightSource',
	[0x01000000] = 'Animation',
	[0x02000000] = 'HoverOver',
	[0x04000000] = 'Unknown3',
	[0x08000000] = 'Armor',
	[0x10000000] = 'Roof',
	[0x20000000] = 'Door',
	[0x40000000] = 'StairBack',
	[0x80000000] = 'StairRight',
	}

Tile = {}

function Tile:New(n_Layer, n_ID, s_Name, n_Flags)

	local obj = {}
		obj.Layer = n_Layer
		obj.ID = n_ID
		obj.Name = s_Name
		obj.Flags = n_Flags
	
 