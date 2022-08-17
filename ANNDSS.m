function [PD,ANNData]=ANNDSS(PD,ANNData,SubExtract,ImNames,d,n)
	StartTime=toc;
	fprintf('ANNDSS is starting. Allow for time to determining computationally expensive SPQM\n');

	load('ANN.mat') % load the neural network
	% STEP 1:
	F=im2double(imread(ImNames{d-1})); % load the reference image without filtering
	Fraw=imread(ImNames{d-1}); % load the raw reference image

	% prep data for NN
	if isnan(ANNData.ImageNoiseStd)% Determine level of noise for image if it has not been provided
		ANNData.ImageNoiseStd=ComputeNoise(Fraw)
	end
	NoiseStdNorm=Reg2Norm(ANNData.ImageNoiseStd,NoiseStdmin,NoiseStdmax,ll,ul); % normalise the noise of the image set
	[FxRaw,FyRaw]=imgradientxy(Fraw,'central'); % determine gradients of the raw reference image
	FThresh = imbinarize(F,graythresh(F)); % create threshold image
	if isnan(ANNData.ImageBitDepth) % Determine image bit depth if not provided
		ImageInfo=imfinfo(ImNames{d-1}); % Determine image bit depth
		ANNData.ImageBitDepth=ImageInfo.BitDepth;
	end
	SSEImage=SubsetShanonEntropy(Fraw,ANNData.ImageBitDepth); % determine subset shannon entropy of the image
			
	SubSize=11:2:ANNData.MaxSubSize; % determine the subset sizes to be considered for each query point
	for q=1:size(PD(1).Xos,2) % loop through query points
		EndFlag=0; % declare flag to stop iterations once the data exceeds the limit the ANN was trained on
		for i=1:numel(SubSize) % loop through subset sizes
			if EndFlag==0
				% Determine SSSIG values
				FxRawSub=SubExtract(FxRaw,PD(1).Xos(:,q),SubSize(i));
				FyRawSub=SubExtract(FyRaw,PD(1).Xos(:,q),SubSize(i));			
				SSSIGx(q,i)=sum(FxRawSub(:).^2);
				SSSIGy(q,i)=sum(FyRawSub(:).^2);
				if (SSSIGx(q,i)>SSSIGmax)|(SSSIGy(q,i)>SSSIGmax)
					SSSIGx(q,i)=NaN; 
					SSSIGy(q,i)=NaN;
					IVR(q,i)=NaN;
					SIV(q,i)=NaN;
					SE(q,i)=NaN;
					SSESub(q,i)=NaN;
					EndFlag=1;
				else
					FrawSub2=SubExtract(Fraw,PD(1).Xos(:,q),SubSize(i)+2); % determine subset of raw image which has an extra pixel in each direction as required by subset intensity variation and subset entropy speckle pattern quality metrics (SPQMs)
					IVR(q,i)=IntensityVariationRatio(SubExtract(FThresh,PD(1).Xos(:,q),SubSize(i)));
					SIV(q,i)=SubsetIntensityVariation(FrawSub2); % needs to be 1 larger than subset in each direction
					SE(q,i)=SubsetEntropy(FrawSub2,ANNData.ImageBitDepth); % needs to be 1 bigger than subset in each direction 
					SSESub(q,i)=SubsetShanonEntropy(SubExtract(Fraw,PD(1).Xos(:,q),SubSize(i)),ANNData.ImageBitDepth);
				end
			else
				SSSIGx(q,i)=NaN; 
				SSSIGy(q,i)=NaN;
				IVR(q,i)=NaN;
				SIV(q,i)=NaN;
				SE(q,i)=NaN;
				SSESub(q,i)=NaN;
			end
		end		
	end
	SPQMTime=toc;

	testPredictionsX=NaN(size(PD(1).Xos,2),numel(SubSize));
	testPredictionsY=NaN(size(PD(1).Xos,2),numel(SubSize));

	% Normalise the SPQMs
	[r,c]=size(SSSIGx);
	SSSIGxNorm=reshape(Reg2Norm(SSSIGx,SSSIGmin,SSSIGmax,ll,ul),[r*c,1]);
	SSSIGyNorm=reshape(Reg2Norm(SSSIGy,SSSIGmin,SSSIGmax,ll,ul),[r*c,1]);
	IVRNorm=reshape(Reg2Norm(IVR,IVRmin,IVRmax,ll,ul),[r*c,1]);
	SIVNorm=reshape(Reg2Norm(SIV,SIVmin,SIVmax,ll,ul),[r*c,1]);
	SENorm=reshape(Reg2Norm(SE,SEmin,SEmax,ll,ul),[r*c,1]);
	SSESubNorm=reshape(Reg2Norm(SSESub,SSEmin,SSEmax,ll,ul),[r*c,1]);
	SSEImageNorm=reshape(Reg2Norm(SSEImage.*ones(size(SSESub)),SSEImagemin,SSEImagemax,ll,ul),[r*c,1]);

	toc1=toc;

	DESDx = reshape(Norm2Reg(predict(Mdlx,[SSSIGxNorm,NoiseStdNorm*ones(size(SSSIGxNorm)),SIVNorm,SENorm,SSESubNorm,SSEImageNorm,IVRNorm]),DESDmin,DESDmax,ll,ul),[r,c]);
	DESDy = reshape(Norm2Reg(predict(Mdlx,[SSSIGyNorm,NoiseStdNorm*ones(size(SSSIGxNorm)),SIVNorm,SENorm,SSESubNorm,SSEImageNorm,IVRNorm]),DESDmin,DESDmax,ll,ul),[r,c]);

	NNTime=toc-toc1;

	% save ANN inputs and outputs
	ProcData.SSSIGx=SSSIGx;
	ProcData.SSSIGy=SSSIGy;
	ProcData.SIV=SIV;
	ProcData.SE=SE;
	ANNData.SSESub=SSESub;
	ANNData.SSEImage=SSEImage;
	ANNData.IVR=IVR;
	ANNData.DESDx=DESDx;
	ANNData.DESDy=DESDy;

	% STEP 2:
	figure
	hold on
	plot(SSSIGx(:),DESDx(:),'.')
	plot(SSSIGy(:),DESDy(:),'.')
	xlabel('SSSIG')
	ylabel('DESD [pixels]')
	ylim([0 0.2])
	[~,DESDThreshold]=ginput(1);
	ANNData.DESDThreshold=DESDThreshold;

	% STEP 3:
	CountSubsEqMax=0;
	for q=1:size(PD(1).Xos,2) % loop through query points
		indx=find((DESDx(q,:)<DESDThreshold)&(SSSIGx(q,:)>0.1),1,'first');
		indy=find((DESDy(q,:)<DESDThreshold)&(SSSIGy(q,:)>0.1),1,'first');
		if isempty(indx)|isempty(indy)
			ind(q)=numel(DESDx(q,:));
			ANNData.AppointedSubsetIndex=numel(DESDx(q,:));
			CountSubsEqMax=CountSubsEqMax+1;
		else
			ind(q)=max([indx,indy]);
			ANNData.AppointedSubsetIndex=max([indx,indy]);
		end
	end

	for q=1:size(PD(1).Xos,2)
		for dd=1:n
			PD(dd).SubSize(q)=SubSize(ind(q));
		end
	end

	fprintf('ANN took %.2f sec\nMean subset size: %.2f\t\tStandard deviation of subset size: %.2f\nNumber of subsets equivalent to maximum allowable: %d (%.2f %%)\n',toc-StartTime, mean(PD(1).SubSize(:)),std(PD(1).SubSize(:)),CountSubsEqMax,CountSubsEqMax/numel(PD(1).SubSize(:)))


end