clear all; clc;
bdrawDebug=true;
bShouldNormalizePts=true;
bAssumeTrueMatches=true;
img1=imread('library1.jpg');
img2=imread('library2.jpg');

matches=load('library_matches.txt');

numberMatches=size(matches,1);

if(bdrawDebug)

	figure;imshow([img1,img2]); hold on; title('Overlay detected features(corners)');
	hold on; plot(matches(:,1),matches(:,2),'ys');
	plot(matches(:,3) + size(img1,2),matches(:,4),'ys');


	figure;imshow([img1 img2]);hold on;%title('')
	plot(matches(:,1),matches(:,2),'+r');
	plot(matches(:,3)+size(img1,2),matches(:,4),'+r');
	line([matches(:,1) matches(:,3) + size(img1,2)]', matches(:,[2 4])', 'Color','r');	

end

%%%%%%%%%FITTING A FUNDAMENTAL MATRIX

if (bAssumeTrueMatches)
	display('Assuming all matches are true and are fitting well ');
	choice=input('Enter 1 for normalized, any other key for fitting the fundamental matches without normalization');
	if(choice==1)
		F=fit_fundamental(matches,true);
	else
		F=fit_fundamental(matches,false);
	end
else
		display('Estimating the fundamental matrix');
		F=estimate_fundamental(matches,bShouldNormalizePts);
	end
	residuals=calc_residuals(F,matches);
	display(['Mean residual is :',num2str(mean(residuals))]);

	L=(F * [matches(:,1:2) ones(numberMatches,1)]')';

	L= L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2),1,3);
	pt_line_dist=sum(L .* [matches(:,3:4) ones(numberMatches,1)],2);
	closest_pt=matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist,1,2);
	pt1=closest_pt - [L(:,2) - L(:,1)] * 10;
	pt2=closest_pt + [L(:,2) - L(:,1)] * 10;
	figure;
	imshow(img2);hold on;
	line([matches(:,3) closest_pt(:,1)]',[matches(:,4) closest_pt(:,2)]','Color','r');
	line([pt1(:,1) pt2(:,1)]',[pt1(:,2) pt2(:,2)]','Color','g')


camMatrix1=load('house1_camera.txt');
camCenter1=get_cam_center(camMatrix1);

camMatrix2=load('house2_camera.txt');
camCenter2=get_cam_center(camMatrix2);

x1=cart_2_homo(matches(:,1:2));
x2=cart_2_homo(matches(:,3:4));
numberMatches=size(x1,1);

triangpoints=zeros(numberMatches,3);
projPointsimage1=zeros(numberMatches,2);
projPointsimage2=zeros(numberMatches,2);

for i=1:numberMatches
	pt1=x1(i,:);
	pt2=x2(i,:);
    crossProductMat1 = [  0   -pt1(3)  pt1(2); pt1(3)   0   -pt1(1); -pt1(2)  pt1(1)   0  ];
    crossProductMat2 = [  0   -pt2(3)  pt2(2); pt2(3)   0   -pt2(1); -pt2(2)  pt2(1)   0  ];    
	Equations=[crossProductMat1*camMatrix1;crossProductMat2*camMatrix2];

	[~,~,V]=svd(Equations);
	triangpointsHomo=V(:,end)';
	triangpoints(i,:)=homo_2_cart(triangpointsHomo);
	projPointsimage1(i,:) = homo_2_cart((camMatrix1*triangpointsHomo')');
	projPointsimage2(i,:) = homo_2_cart((camMatrix2*triangpointsHomo')');
end

    
    figure; axis equal;hold on;
	plot3(-triangpoints(:,1),triangpoints(:,2), triangpoints(:,3),'.r');
	plot3(-camCenter1(1),camCenter1(2),camCenter1(3),'*g');
	plot3(-camCenter2(1),camCenter2(2),camCenter2(3),'*b');
	grid on;xlabel('x');ylabel('y');zlabel('z');axis equal;
   
    
    distances1=diag(dist2(matches(:,1:2), projPointsimage1));
    distances2=diag(dist2(matches(:,1:2), projPointsimage2));
    display(['Mean residual 1:',num2str(mean(distances1))]);
    display(['Mean residual 2:',num2str(mean(distances2))]);



	
