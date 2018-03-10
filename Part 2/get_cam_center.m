function [centerofthecamera]=get_cam_center(cameramatrix)

[~,~,A]=svd(cameramatrix);
centerofthecamera=A(:,end);
centerofthecamera=homo_2_cart(centerofthecamera');
end
