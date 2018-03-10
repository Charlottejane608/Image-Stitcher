clear all;
clc;
Colorimg1=imread('../data/part1/pier/1.JPG');
Colorimg2=imread('../data/part1/pier/2.JPG');
Colorimg1=im2double(Colorimg1);
Colorimg2=im2double(Colorimg2);
img1=rgb2gray(Colorimg1);
img2=rgb2gray(Colorimg2);

[h1, w1, ~]=size(img1);
[h2, w2, ~]=size(img2);


[r1, c1, r2, c2]=detect_features(img1,img2);

figure; imshow([Colorimg1 Colorimg2]); hold on; title('Overlay detected features (corners)');
hold on; plot(c1,r1,'ys'); plot(c2+w1,r2,'ys');

neighborhoodradius=50;
FeatureDescriptions1=describe_features(img1,neighborhoodradius,r1,c1);
FeatureDescriptions2=describe_features(img2,neighborhoodradius,r2,c2);


%%MATCHING THEM COOL FEATURES

numberMatches=200;
[img1_matchfeat_idx,img2_matchfeat_idx]=match_features(numberMatches,FeatureDescriptions1,FeatureDescriptions2);
matchR1=r1(img1_matchfeat_idx);
matchC1=c1(img1_matchfeat_idx);
matchR2=r2(img2_matchfeat_idx);
matchC2=c2(img2_matchfeat_idx);

figure; imshow([Colorimg1 Colorimg2]); hold on; title('Overlay top matched features');
hold on; plot(matchC1,matchR1,'ys');plot(matchC2+w1,matchR2,'ys');

plotR=[matchR1,matchR2];
plotC=[matchC1,matchC2 + w1];
figure; imshow([Colorimg1 Colorimg2]); hold on; title('Mapping of top matched features');
hold on; 
plot(matchC1,matchR1,'ys');
plot(matchC2+w1,matchR2,'ys');
for i=1:numberMatches
	plot(plotC(i,:),plotR(i,:));
end


%%%HOMOS ROCK

img1matchedpoints=[matchC1,matchR1,ones(numberMatches,1)];
img2matchedpoints=[matchC2,matchR2,ones(numberMatches,1)];
[H, inlierindices]=estimate_homography(img1matchedpoints,img2matchedpoints);

matchC1=matchC1(inlierindices);
matchC2=matchC2(inlierindices);
matchR1=matchR1(inlierindices);
matchR2=matchR2(inlierindices);

figure; imshow([Colorimg1 Colorimg2]);hold on; title('Inlier Matches');
hold on;plot(matchC1,matchR1,'ys');plot(matchC2+w1,matchR2,'ys');

homographyTransform=maketform('projective',H);
finalimage=imtransform(Colorimg1,homographyTransform);
figure,imshow(finalimage);
title('Warped Image');

%%%SARTORIAL SHIT!!
stitchedImg=stitch(Colorimg1, Colorimg2,H);
imwrite(stitchedImg,'Arigato.jpg');
figure, imshow(stitchedImg);
title('Alignment by Homography');
