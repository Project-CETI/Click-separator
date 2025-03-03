%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% Detetion and source separation algorithm for sperm whale locomotion signals ("Echolocation clicks")  %%%
                                    %% Main script%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc;

%% Arrange folder paths
PF=pwd;
PF=[PF '\functions']; % program folder path
Rec_folder=uigetdir([PF '\', 'Select audio Folder']); % audio folder path
cd(PF)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load model parameters
 load All_objs.mat
 load Buffer_Params
 load F_weights

 %% Default parameters

 Buffer_length=3;    % Analysis buffer length [sec] 
 lone_p=20;          % Lone penalty (used for click train formation)      
 ITI_min=-4;         % minimum allowed time gap (Inter-train interval (ITI)) between click trains [sec]
 ITI_max=30;         % maximum allowed time gap (Inter-train interval (ITI)) between click trains [sec]
 Amplitude_lim=8e-3; % minimum allowed signal amplitude
 roi=16e-3;          % region of interest (roi)- defines the time window [in sec] around clicks for analyzing their surface echo

%% Run on selected files

cd(Rec_folder);     
Files=dir('*.wav');
% Files=dir('*.flac');

%% Run the algorithm on each audio file within the selected folder
for fi=1:length(Files)
        filename=Files(fi).name;
        cd(Rec_folder);
        [test,F_ds] = audioread(filename); % load signal 
        cd(PF); 
        test=bandpass(test(:,1),[2e3,24e3],F_ds); % apply band pass filter
        t_test=(0:1/F_ds: (1/F_ds)*(length(test)-1))';
        %% show signal
        figure('units','normalized','outerposition',[0 0 1 1]) 
        subplot(2,2,1);
        plot(t_test,test); hold on;
        xlabel('time [sec]'); ylabel('Voltage [v]');  
        XL = get(gca, 'XLim'); xlim(XL); 
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% run separation algorithm %%%%%%%%%%%%%%%%%%%%%%%%
         %%  Click separation within buffers
                        
        Detections=run_subtrain_detect(roi,F_weights,Buffer_length,test,F_ds,All_objs,Amplitude_lim);    
        
        %%  Click train formation (sequences' association between buffers)

        [trajectories,id_j_ToAs]=run_train(Detections,Buffer_Params,test,F_ds,roi);

        %% Association of click trains

        Det=run_trains_association_algo(trajectories,id_j_ToAs,ITI_min,ITI_max,lone_p,roi,test,F_ds);
            
        %% Store separation results

        cd(Rec_folder)
        FN = ['Separated_whales_' filename(1:end-4) '.csv'];       
        if exist(FN, 'file')
            delete(FN);
        end
        fid = fopen(FN, 'a');
        for W_ind=1:size(Det,2)
            Output_clicks=Det(W_ind).ToAs';
            fprintf(fid, '%s\n', strjoin(string(Output_clicks), ','));
        end
        fclose(fid);
end
