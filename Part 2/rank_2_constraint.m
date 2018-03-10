function [rank2_mat ] = rank_2_constraint(mat)

	[A,B,C]=svd(mat);

	B(end)=0;

	rank2_mat=A*B*C';
end

