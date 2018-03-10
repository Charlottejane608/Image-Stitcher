function[cartcoords] =homo_2_cart(homocoords)
	dimension=size(homocoords,2) - 1;
	normalcoords=bsxfun(@rdivide,homocoords,homocoords(:,end));
	cartcoords=normalcoords(:,1:dimension);
end
