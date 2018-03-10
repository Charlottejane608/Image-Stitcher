function [homoCoords] = cart_2_homo(cartCoordinates)
	[NumberCoordinates,dimension]=size(cartCoordinates);
	homoCoords=ones(NumberCoordinates,dimension+1);
	homoCoords(:,1:dimension)=cartCoordinates(:,1:dimension);
end
