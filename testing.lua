local tbl_parres = {
	[1] 	= { {nil},											nil   },
	[2] 	= { {nil, nil},										nil   },
	[3] 	= { {{}, nil},										nil   },
	[4] 	= { {nil, 1},										nil   },
	[5] 	= { {table.remove({}, 1), 1}, 						nil   },
	[6] 	= { {{}, table.remove({}, 1)},						nil   },
	[7] 	= { {1, 1}, 										false },
	[8] 	= { {"{1}", 1},										false },
	[9]		= { {true, 1},										false },
	[10] 	= { {{}, 1},										false },
	[11]	= { {{1}, 0},										false },
	[12]	= { {{[0]=1}, 1},									false },
	[13]	= { {{1}, {1}},										false },
	[14]	= { {{1}, "1"},										false },
	[15]	= { {{0,1,2}, 0},									false },
	[16]	= { {{0,1,2}, 4},									false },
	[17]	= { {{0,{},2}, 2, 1},								false },
	[18]	= { {{0,{{}},2}, 2, 2},								false },
	[19]	= { {{{1},{2},{3}}, 1},								true  },
	[20]	= { {{{1},{2},{3}}, 3},								true  },
	[21]	= { {{{[3]={[0]={}}},{2},{3}}, 1, 3, 0},			true  },
	[22]	= { {{{[0] = {[356]={[-1]=0}}},{3}}, 0, 356, -1},	true  },
}
dofile(getinstalldir().."scripts\\test.lua")
dofile(getinstalldir().."scripts\\graphlib.lua")
Test(IsIndexExist, tbl_parres)