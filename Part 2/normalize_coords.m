function [transform, normalizedchords]= normalize_coords(homoCoords)

	center=mean(homoCoords(:,1:2));

	offset=eye(3); %creating an identity matrix of size 3 x 3
	scale=eye(3);
	offset(1,3)=-center(1); %mu_x
	offset(2,3)=-center(2); %mu_y

	sX=max(abs(homoCoords(:,1)));
	sY=max(abs(homoCoords(:,2)));

	scale(1,1)=1/sX;
	scale(2,2)=1/sY;

	transform=scale * offset;
	normalizedchords=(transform * homoCoords')';
end
