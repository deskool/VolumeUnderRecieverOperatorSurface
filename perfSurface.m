function [VUS] = perfSurface(out, P)
% calculating volume under surface in 3 class predictions
%
%   out -   oracle labels       (examples x class)
%   P   -   predicted labels    (examples x class)

    warning('off','MATLAB:scatteredInterpolant:DupPtsAvValuesWarnId');
    all_data = [P,out];

    all_data = sortrows(all_data);
    P = all_data(:,1:3);
    out = all_data(:,4:end);
    uniqueP_1 = [0;unique(round(P(:,1),2));1];
    uniqueP_2 = [0;unique(round(P(:,2),2));1];
    sensitivity = zeros(3,length(uniqueP_1)*length(uniqueP_2));
    for i = 1:length(uniqueP_1)
        v_thresh = uniqueP_1(i);
        v = v_thresh*ones(size(P,1),1);
        for j = 1:length(uniqueP_2)
            w_thresh = uniqueP_2(j);
            w = w_thresh*ones(size(P,1),1);

            % GET PREDICTED CLASSES AND SENSITIVITY
            [~,maxP] = max([P(:,1) - v, P(:,2) - w, P(:,3)]');
            pred_dummy = double([maxP == 1; maxP == 2; maxP == 3]);
            [~,cm,~,~] = confusion(out', pred_dummy);
            sensitivity(:,(i-1)*length(uniqueP_2)+j) = diag(cm)./sum(cm,2);
        end
    end
    
    sensitivity = unique(sensitivity','rows')';
    x = [sensitivity(1,1:end),1,0,1,0];
    y = [sensitivity(2,1:end),1,1,0,0];
    z = [sensitivity(3,1:end),0,0,0,1];

    % INTERPOLATING AND GETTING VOLUME UNDER SURFACE
    interpZ = @(xq,yq) griddata(x,y,z,xq,yq);
    VUS = quad2d(interpZ,0,1,0,1);

end