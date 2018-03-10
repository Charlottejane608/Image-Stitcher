function [cartCoord]=homo_2_cart(homoCoord)


	dimension=size(homoCoord,2) -1;
	normCoord=bsxfun(@rdivide,homoCoord,homoCoord(:,end));
	cartCoord=normCoord(:,1:dimension);

end
