function Test(f_function, tbl_parres)
	for n_iarrayindex = 1, #tbl_parres do
		if f_function(unpack(tbl_parres[n_iarrayindex][1])) ~= tbl_parres[n_iarrayindex][2] then
			print("FAILED! Test failed at "..n_iarrayindex.." element.")
			stop()
		end
	end
	print("OK! Test passed.")
end