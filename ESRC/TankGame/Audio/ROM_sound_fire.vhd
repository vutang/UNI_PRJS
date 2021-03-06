LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY ROM_sound_fire IS
	PORT(	rom_address				: 	IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
			rom_data				: 	OUT	STD_LOGIC_VECTOR(15 DOWNTO 0));
END ROM_sound_fire;

ARCHITECTURE a OF ROM_sound_fire IS
--	SIGNAL	rom_data			: STD_LOGIC_VECTOR(7 DOWNTO 0);
--	SIGNAL	rom_address			: STD_LOGIC_VECTOR(10 DOWNTO 0);
BEGIN
				-- Small 8 by 8 Character Generator ROM for Video Display
				-- Each character is eight 8-bits words of pixel data
--	rom_address <= character_address & font_row;
--	rom_mux_output <= rom_data ((CONV_INTEGER(NOT font_col(2 DOWNTO 0))));			
	
With rom_address select
				--@
	rom_data 	<= 	 x"03df"	 	when	x"000",
						x"dcd8"		when	x"001",
						x"ead2"		when	x"002",
						x"1728"		when	x"003",
						x"27d3"		when	x"004",
						x"fe81"		when	x"005",
						x"d563"		when	x"006",
						x"ee2b"		when	x"007",
						x"25d4"		when	x"008",
						x"2740"		when	x"009",
						x"e9ad"		when	x"00a",
						x"d281"		when	x"00b",
						x"fe72"		when	x"00c",
						x"3298"		when	x"00d",
						x"1a48"		when	x"00e",
						x"d95f"		when	x"00f",
						x"d505"		when	x"010",
						x"1125"		when	x"011",
						x"3805"		when	x"012",
						x"0297"		when	x"013",
						x"ccee"		when	x"014",
						x"e553"		when	x"015",
						x"2617"		when	x"016",
						x"3211"		when	x"017",
						x"edb9"		when	x"018",
						x"caa8"		when	x"019",
						x"f87f"		when	x"01a",
						x"369d"		when	x"01b",
						x"1fc9"		when	x"01c",
						x"db1d"		when	x"01d",
						x"d122"		when	x"01e",
						x"0af1"		when	x"01f",
						x"3ad1"		when	x"020",
						x"105f"		when	x"021",
						x"ce2b"		when	x"022",
						x"dbe4"		when	x"023",
						x"1d2e"		when	x"024",
						x"36b1"		when	x"025",
						x"fa9f"		when	x"026",
						x"ca4e"		when	x"027",
						x"eb2a"		when	x"028",
						x"2b88"		when	x"029",
						x"3069"		when	x"02a",
						x"e9b7"		when	x"02b",
						x"cbd2"		when	x"02c",
						x"fbd5"		when	x"02d",
						x"302e"		when	x"02e",
						x"21cd"		when	x"02f",
						x"e05b"		when	x"030",
						x"d345"		when	x"031",
						x"0579"		when	x"032",
						x"333b"		when	x"033",
						x"1553"		when	x"034",
						x"d834"		when	x"035",
						x"dd03"		when	x"036",
						x"11b6"		when	x"037",
						x"33ed"		when	x"038",
						x"085d"		when	x"039",
						x"d4f2"		when	x"03a",
						x"e22c"		when	x"03b",
						x"1752"		when	x"03c",
						x"31c9"		when	x"03d",
						x"00f3"		when	x"03e",
						x"d1a0"		when	x"03f",
						x"e6e9"		when	x"040",
						x"2242"		when	x"041",
						x"30d1"		when	x"042",
						x"f42c"		when	x"043",
						x"d0b5"		when	x"044",
						x"eff6"		when	x"045",
						x"264b"		when	x"046",
						x"2ca6"		when	x"047",
						x"ef8d"		when	x"048",
						x"d2ee"		when	x"049",
						x"f510"		when	x"04a",
						x"2a8f"		when	x"04b",
						x"2961"		when	x"04c",
						x"e9ec"		when	x"04d",
						x"d1db"		when	x"04e",
						x"f93a"		when	x"04f",
						x"2bf7"		when	x"050",
						x"212d"		when	x"051",
						x"e660"		when	x"052",
						x"d2eb"		when	x"053",
						x"faab"		when	x"054",
						x"2d07"		when	x"055",
						x"2039"		when	x"056",
						x"e3b7"		when	x"057",
						x"d94f"		when	x"058",
						x"fef6"		when	x"059",
						x"292f"		when	x"05a",
						x"1ba6"		when	x"05b",
						x"e535"		when	x"05c",
						x"db6b"		when	x"05d",
						x"fec3"		when	x"05e",
						x"2a68"		when	x"05f",
						x"196b"		when	x"060",
						x"e5ae"		when	x"061",
						x"da3c"		when	x"062",
						x"fdfc"		when	x"063",
						x"2d08"		when	x"064",
						x"1b5f"		when	x"065",
						x"e4f5"		when	x"066",
						x"d84d"		when	x"067",
						x"fc47"		when	x"068",
						x"2bec"		when	x"069",
						x"1efa"		when	x"06a",
						x"e4dd"		when	x"06b",
						x"d86d"		when	x"06c",
						x"fc60"		when	x"06d",
						x"29e7"		when	x"06e",
						x"1d9d"		when	x"06f",
						x"e501"		when	x"070",
						x"d67e"		when	x"071",
						x"fa45"		when	x"072",
						x"2dd6"		when	x"073",
						x"1f0a"		when	x"074",
						x"e5a2"		when	x"075",
						x"d59a"		when	x"076",
						x"fb52"		when	x"077",
						x"2f32"		when	x"078",
						x"20bf"		when	x"079",
						x"e717"		when	x"07a",
						x"d201"		when	x"07b",
						x"f9ff"		when	x"07c",
						x"2e98"		when	x"07d",
						x"22b6"		when	x"07e",
						x"e87d"		when	x"07f",
						x"d23c"		when	x"080",
						x"f66a"		when	x"081",
						x"2914"		when	x"082",
						x"269c"		when	x"083",
						x"f0bf"		when	x"084",
						x"d108"		when	x"085",
						x"ed73"		when	x"086",
						x"23ab"		when	x"087",
						x"2d45"		when	x"088",
						x"f5ff"		when	x"089",
						x"d0f5"		when	x"08a",
						x"e557"		when	x"08b",
						x"2004"		when	x"08c",
						x"33c7"		when	x"08d",
						x"ffc9"		when	x"08e",
						x"d110"		when	x"08f",
						x"df61"		when	x"090",
						x"1a08"		when	x"091",
						x"3705"		when	x"092",
						x"04d3"		when	x"093",
						x"d1f5"		when	x"094",
						x"d8f8"		when	x"095",
						x"13f8"		when	x"096",
						x"3904"		when	x"097",
						x"0cd9"		when	x"098",
						x"d314"		when	x"099",
						x"d5d1"		when	x"09a",
						x"0e01"		when	x"09b",
						x"36ce"		when	x"09c",
						x"12a1"		when	x"09d",
						x"d78c"		when	x"09e",
						x"d569"		when	x"09f",
						x"0881"		when	x"0a0",
						x"33d9"		when	x"0a1",
						x"1bba"		when	x"0a2",
						x"e34f"		when	x"0a3",
						x"d4f8"		when	x"0a4",
						x"fa95"		when	x"0a5",
						x"2b1d"		when	x"0a6",
						x"22b3"		when	x"0a7",
						x"f3e9"		when	x"0a8",
						x"d741"		when	x"0a9",
						x"ea3d"		when	x"0aa",
						x"189d"		when	x"0ab",
						x"2867"		when	x"0ac",
						x"0897"		when	x"0ad",
						x"e37b"		when	x"0ae",
						x"db29"		when	x"0af",
						x"00fc"		when	x"0b0",
						x"235a"		when	x"0b1",
						x"1b96"		when	x"0b2",
						x"f9b7"		when	x"0b3",
						x"e038"		when	x"0b4",
						x"ea1f"		when	x"0b5",
						x"0dbb"		when	x"0b6",
						x"2129"		when	x"0b7",
						x"0f9b"		when	x"0b8",
						x"f408"		when	x"0b9",
						x"e2f7"		when	x"0ba",
						x"f06f"		when	x"0bb",
						x"0ac1"		when	x"0bc",
						x"183e"		when	x"0bd",
						x"1311"		when	x"0be",
						x"fa98"		when	x"0bf",
						x"e6d0"		when	x"0c0",
						x"e8a0"		when	x"0c1",
						x"03d4"		when	x"0c2",
						x"2154"		when	x"0c3",
						x"1f8b"		when	x"0c4",
						x"f719"		when	x"0c5",
						x"d9b8"		when	x"0c6",
						x"e076"		when	x"0c7",
						x"0c17"		when	x"0c8",
						x"31f6"		when	x"0c9",
						x"1f59"		when	x"0ca",
						x"e728"		when	x"0cb",
						x"ccff"		when	x"0cc",
						x"e939"		when	x"0cd",
						x"2162"		when	x"0ce",
						x"371f"		when	x"0cf",
						x"0feb"		when	x"0d0",
						x"d810"		when	x"0d1",
						x"d013"		when	x"0d2",
						x"f925"		when	x"0d3",
						x"2bef"		when	x"0d4",
						x"3246"		when	x"0d5",
						x"fd6b"		when	x"0d6",
						x"ce0b"		when	x"0d7",
						x"d59e"		when	x"0d8",
						x"0d1c"		when	x"0d9",
						x"3ba0"		when	x"0da",
						x"2928"		when	x"0db",
						x"e890"		when	x"0dc",
						x"c4c7"		when	x"0dd",
						x"e256"		when	x"0de",
						x"22e2"		when	x"0df",
						x"3a56"		when	x"0e0",
						x"1017"		when	x"0e1",
						x"d62c"		when	x"0e2",
						x"d1cf"		when	x"0e3",
						x"fb02"		when	x"0e4",
						x"2577"		when	x"0e5",
						x"2cab"		when	x"0e6",
						x"01b0"		when	x"0e7",
						x"dbad"		when	x"0e8",
						x"dc32"		when	x"0e9",
						x"fbd4"		when	x"0ea",
						x"2268"		when	x"0eb",
						x"2a5a"		when	x"0ec",
						x"06af"		when	x"0ed",
						x"dbc7"		when	x"0ee",
						x"d53c"		when	x"0ef",
						x"f987"		when	x"0f0",
						x"2d60"		when	x"0f1",
						x"2ed1"		when	x"0f2",
						x"fcac"		when	x"0f3",
						x"d0df"		when	x"0f4",
						x"d60a"		when	x"0f5",
						x"058f"		when	x"0f6",
						x"3495"		when	x"0f7",
						x"28b1"		when	x"0f8",
						x"f05e"		when	x"0f9",
						x"cf0a"		when	x"0fa",
						x"def2"		when	x"0fb",
						x"107b"		when	x"0fc",
						x"331f"		when	x"0fd",
						x"22c0"		when	x"0fe",
						x"ecfc"		when	x"0ff",
						x"d1b4"		when	x"100",
						x"e41c"		when	x"101",
						x"15c8"		when	x"102",
						x"33a0"		when	x"103",
						x"19f8"		when	x"104",
						x"e696"		when	x"105",
						x"d1b9"		when	x"106",
						x"e5c8"		when	x"107",
						x"19dd"		when	x"108",
						x"3510"		when	x"109",
						x"13dd"		when	x"10a",
						x"e115"		when	x"10b",
						x"d21e"		when	x"10c",
						x"ec47"		when	x"10d",
						x"1e72"		when	x"10e",
						x"31e0"		when	x"10f",
						x"0ece"		when	x"110",
						x"df32"		when	x"111",
						x"d078"		when	x"112",
						x"efd3"		when	x"113",
						x"2276"		when	x"114",
						x"3405"		when	x"115",
						x"0ad7"		when	x"116",
						x"dafd"		when	x"117",
						x"d4d6"		when	x"118",
						x"f4cd"		when	x"119",
						x"2463"		when	x"11a",
						x"309d"		when	x"11b",
						x"0502"		when	x"11c",
						x"db98"		when	x"11d",
						x"d5bf"		when	x"11e",
						x"f553"		when	x"11f",
						x"20f8"		when	x"120",
						x"2b5e"		when	x"121",
						x"09b2"		when	x"122",
						x"decc"		when	x"123",
						x"d67e"		when	x"124",
						x"f3b3"		when	x"125",
						x"22c1"		when	x"126",
						x"2f4f"		when	x"127",
						x"0c29"		when	x"128",
						x"dee8"		when	x"129",
						x"d568"		when	x"12a",
						x"f1e0"		when	x"12b",
						x"241a"		when	x"12c",
						x"30a6"		when	x"12d",
						x"0df9"		when	x"12e",
						x"e269"		when	x"12f",
						x"d420"		when	x"130",
						x"ef82"		when	x"131",
						x"1b54"		when	x"132",
						x"2dfb"		when	x"133",
						x"11f7"		when	x"134",
						x"e6d1"		when	x"135",
						x"d5fe"		when	x"136",
						x"e8ea"		when	x"137",
						x"17c9"		when	x"138",
						x"32b9"		when	x"139",
						x"1e2e"		when	x"13a",
						x"ecb9"		when	x"13b",
						x"cc96"		when	x"13c",
						x"de74"		when	x"13d",
						x"127a"		when	x"13e",
						x"398b"		when	x"13f",
						x"2417"		when	x"140",
						x"ed78"		when	x"141",
						x"c4df"		when	x"142",
						x"d7bb"		when	x"143",
						x"11ce"		when	x"144",
						x"3c4b"		when	x"145",
						x"2a8d"		when	x"146",
						x"f073"		when	x"147",
						x"c75d"		when	x"148",
						x"d2a9"		when	x"149",
						x"0709"		when	x"14a",
						x"3c3f"		when	x"14b",
						x"32b3"		when	x"14c",
						x"fce5"		when	x"14d",
						x"c9cb"		when	x"14e",
						x"cabc"		when	x"14f",
						x"021a"		when	x"150",
						x"3be2"		when	x"151",
						x"3a1f"		when	x"152",
						x"039a"		when	x"153",
						x"c88b"		when	x"154",
						x"c639"		when	x"155",
						x"f8b4"		when	x"156",
						x"365e"		when	x"157",
						x"3c2c"		when	x"158",
						x"093c"		when	x"159",
						x"cd4a"		when	x"15a",
						x"c28c"		when	x"15b",
						x"f250"		when	x"15c",
						x"2ee1"		when	x"15d",
						x"3e5e"		when	x"15e",
						x"1029"		when	x"15f",
						x"d723"		when	x"160",
						x"c7f2"		when	x"161",
						x"e926"		when	x"162",
						x"2366"		when	x"163",
						x"3f22"		when	x"164",
						x"1c6b"		when	x"165",
						x"e4d1"		when	x"166",
						x"c6b8"		when	x"167",
						x"de2c"		when	x"168",
						x"143b"		when	x"169",
						x"35c1"		when	x"16a",
						x"24fe"		when	x"16b",
						x"f420"		when	x"16c",
						x"d3a4"		when	x"16d",
						x"d881"		when	x"16e",
						x"fc68"		when	x"16f",
						x"2339"		when	x"170",
						x"29de"		when	x"171",
						x"0d6b"		when	x"172",
						x"eb21"		when	x"173",
						x"d7fb"		when	x"174",
						x"e45d"		when	x"175",
						x"0543"		when	x"176",
						x"23cc"		when	x"177",
						x"26b5"		when	x"178",
						x"0c6a"		when	x"179",
						x"e73f"		when	x"17a",
						x"d85e"		when	x"17b",
						x"e581"		when	x"17c",
						x"0774"		when	x"17d",
						x"2754"		when	x"17e",
						x"2a27"		when	x"17f",
						x"0724"		when	x"180",
						x"e3b0"		when	x"181",
						x"d1a2"		when	x"182",
						x"e727"		when	x"183",
						x"1091"		when	x"184",
						x"30d8"		when	x"185",
						x"2917"		when	x"186",
						x"00a7"		when	x"187",
						x"d739"		when	x"188",
						x"cb03"		when	x"189",
						x"ec7c"		when	x"18a",
						x"1dd2"		when	x"18b",
						x"3d2c"		when	x"18c",
						x"238e"		when	x"18d",
						x"ef6f"		when	x"18e",
						x"c71a"		when	x"18f",
						x"d120"		when	x"190",
						x"0046"		when	x"191",
						x"3476"		when	x"192",
						x"380a"		when	x"193",
						x"0d7a"		when	x"194",
						x"db95"		when	x"195",
						x"cd88"		when	x"196",
						x"e2a1"		when	x"197",
						x"1678"		when	x"198",
						x"3757"		when	x"199",
						x"2797"		when	x"19a",
						x"fcf5"		when	x"19b",
						x"d504"		when	x"19c",
						x"d21f"		when	x"19d",
						x"f19d"		when	x"19e",
						x"2166"		when	x"19f",
						x"34da"		when	x"1a0",
						x"1ac8"		when	x"1a1",
						x"ea6a"		when	x"1a2",
						x"cfa3"		when	x"1a3",
						x"d98f"		when	x"1a4",
						x"0329"		when	x"1a5",
						x"2cc9"		when	x"1a6",
						x"31ef"		when	x"1a7",
						x"0dac"		when	x"1a8",
						x"ddc6"		when	x"1a9",
						x"cfb2"		when	x"1aa",
						x"e85e"		when	x"1ab",
						x"1254"		when	x"1ac",
						x"2fdf"		when	x"1ad",
						x"1de5"		when	x"1ae",
						x"f860"		when	x"1af",
						x"d9bf"		when	x"1b0",
						x"de61"		when	x"1b1",
						x"0000"		when	others;
END a;