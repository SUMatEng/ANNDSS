clear all; close all; clc;

% Define images
Case=1;
[FileNames]=ImageNamesLoad(Case);


Mask=ones(size(im2double(imread(FileNames{1})))); % define a mask that includes all pixels of the image
Mask(1,:)=0; Mask(end,:)=0; Mask(:,1)=0; Mask(:,end)=0;

% ANN parameters
ImageNoiseStd=4;
ImageBitDepth=8;
MaxSubSize=121;

% Function inputs (which set up the DIC analysis)
GaussFilter=[0.4,5];
StepSize=20;
SubSize=MaxSubSize;
SubShape='Square'; % ANNDSS can only be used with square subset sizes
SFOrder=1;
RefStrat=0;
StopCritVal=1e-4;
WorldCTs=0;
ImageCTs=0;
rho=0;

% perform DIC analysis
[ProcData,ANNData]=ADIC2D(FileNames,Mask,GaussFilter,StepSize,SubSize,SubShape,SFOrder,RefStrat,StopCritVal,WorldCTs,ImageCTs,rho,ImageNoiseStd,ImageBitDepth,MaxSubSize);

% Correct displacements of incremental reference image strategy so that they describe displacement relative to the first image of the image set
if RefStrat==1
    for d=2:max(size(ProcData))
        ProcData(d).Uw=ProcData(d).Uw+ProcData(d-1).Uw;
    end
end

ProcData=AddGridFormat(ProcData); % add gridded matrices for display purposes
figure
surf(ProcData(end).POSX,ProcData(end).POSY,ProcData(end).UX) % display displacement in the x direction for the last image
xlabel('x')
ylabel('y')
zlabel('U')
title('X-direction displacement')
figure
surf(ProcData(end).POSX,ProcData(end).POSY,ProcData(end).UY) % display displacement in the y direction for the last image
xlabel('x')
ylabel('y')
zlabel('V')
title('Y-direction displacement')

if Case==1
    % compute displacement errors depending on the sample analysed
    numSubs=size(ProcData(2).Uw,2);
    for d=2:max(size(ProcData))
        errorx((d-2)*numSubs+1:(d-1)*numSubs)=ProcData(d).Uw(1,:)'-(d-2)*0.1;
        errory((d-2)*numSubs+1:(d-1)*numSubs)=ProcData(d).Uw(2,:)'+(d-2)*0.1;
    end

    DESDActualx=std(errorx(:));
    DESDActualy=std(errory(:));

    fprintf('For the requested DESD of %f ANNDSS returns DESD in the x: %f and y: %f\n',ANNData.DESDThreshold,DESDActualx,DESDActualy)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Support functions:
function out=STD(errin,maer) % calculate the standard deviation
    total=0;
    count=0;
    err=errin(~isnan(errin));
    for i=1:max(size(err))
        total=total+(abs(err(i))-maer)^2;
        count=count+1;
    end
    out=sqrt(total/(count-1));
end

function out=RMSE_calc(err) % calculate the root mean square error
    count=0;
    total=0;
    for i=1:max(size(err))
        total=total+err(i)^2;
        count=count+1;
    end
    out=sqrt(total/count);
end

function [ImName]=ImageNamesLoad(Case) % function to load appropriate images
    ImageLocation=pwd;
    if Case==1
        ImName{1}=fullfile(pwd,'Images/Case1/Im_1.png');
        ImName{2}=fullfile(pwd,'Images/Case1/Im_2.png');
        ImName{3}=fullfile(pwd,'Images/Case1/Im_3.png');
        ImName{4}=fullfile(pwd,'Images/Case1/Im_4.png');
        ImName{5}=fullfile(pwd,'Images/Case1/Im_5.png');
        ImName{6}=fullfile(pwd,'Images/Case1/Im_6.png');
        ImName{7}=fullfile(pwd,'Images/Case1/Im_7.png');
        ImName{8}=fullfile(pwd,'Images/Case1/Im_8.png');
        ImName{9}=fullfile(pwd,'Images/Case1/Im_9.png');
        ImName{10}=fullfile(pwd,'Images/Case1/Im_10.png');
        ImName{11}=fullfile(pwd,'Images/Case1/Im_11.png');
    elseif Case==2

        ImName{1}=fullfile(pwd,'Images/Case2/Im_1.png');
        ImName{2}=fullfile(pwd,'Images/Case2/Im_2.png');
        ImName{3}=fullfile(pwd,'Images/Case2/Im_3.png');
        ImName{4}=fullfile(pwd,'Images/Case2/Im_4.png');
        ImName{5}=fullfile(pwd,'Images/Case2/Im_5.png');
        ImName{6}=fullfile(pwd,'Images/Case2/Im_6.png');
        ImName{7}=fullfile(pwd,'Images/Case2/Im_7.png');
        ImName{8}=fullfile(pwd,'Images/Case2/Im_8.png');
        ImName{9}=fullfile(pwd,'Images/Case2/Im_9.png');
        ImName{10}=fullfile(pwd,'Images/Case2/Im_10.png');
        ImName{11}=fullfile(pwd,'Images/Case2/Im_11.png');
    end
end