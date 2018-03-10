function [F]=fit_fundamental(matches,bShouldNormalize)



	z1=cart_2_homo(matches(:,1:2));
	z2=cart_2_homo(matches(:,3:4));


	if bShouldNormalize

		[transformation1,normalz1]=normalize_coords(z1);
		[transformation2,normalz2]=normalize_coords(z2);
		z1=normalz1;
		z2=normalz2;
	end


	r1=z1(:,1);
	s1=z1(:,2);
	r2=z2(:,1);
	s2=z2(:,2);


	fillerval=[r2 .* r1, r2.* s1, r2, s2 .* r1, s2 .* s1, s2, r1, s1, ones(size(matches,1),1)];
	[~,~,S]=svd(fillerval);
	f_vector=S(:,9);
	F=reshape(f_vector,3,3);
	F=rank_2_constraint(F);


	 if bShouldNormalize
	 	F=transformation2' * F * transformation1;
	 end
	end
	