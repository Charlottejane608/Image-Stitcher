function H= fit_homography(homo_pts1,homo_pts2)
if size(homo_pts1) ~=size(homo_pts2)
error('Number of matches features dont match');
end
[numMatches,~]=size(homo_pts1);
A=[];
for i=1:numMatches
	p1=homo_pts1(i,:);
	p2=homo_pts2(i,:);
	A_i=[zeros(1,3), -p1, p2(2)*p1;
	p1,	zeros(1,3), -p2(1)*p1];

	A=[A;A_i];
end

[~,~,eigenVectors]=svd(A);
h=eigenVectors(:,9);
H=reshape(h,3,3);
H= H ./ H(3,3);
end
