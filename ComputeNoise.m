function s=ComputeNoise(I)
	% IALgorithm to compute standard deviation of image noise based on the work of work Immerkær
	% Immerkær J (1996) Fast noise variance estimation. Comput Vis Image Underst 64:300–302. https://doi.org/10.1006/cviu.1996.0060
	M = [1, -2, 1;
     	-2, 4, -2;
       	1, -2, 1];
	s=sum(sum(abs(conv2(I,M))));
	s=s*sqrt(0.5*pi)/(6*(size(I,1)-2)*(size(I,2)-2));
end