%--------------------------------------------
%TU Application Exercise
%Aryaman Majumdar
%Contains code for all parts of the exercise
%--------------------------------------------
function[] = temple_app()

   %Get all the data in a matrix (separate matrix for each task)
   [A, B] = return_matrix(); 
   
   
   
   %--------------------------------------------------------------------
   %For Parts 1 and 2 - Comparing response times (RTs)
   %--------------------------------------------------------------------
   
   
   %Get the response times from the data matrix
   [FOR_SELF, FOR_PARTNER, FOR_SELF_2, FOR_PARTNER_2] = RT_self_vs_partner(B);

   
   
   %Plot the RT effects for each subject:
   %For Choice 1
   plot_RT__FOR_SELF_V_FOR_PARTNER(FOR_SELF, FOR_PARTNER);
   
   %For Choice 2
   plot_RT__FOR_SELF_V_FOR_PARTNER(FOR_SELF_2, FOR_PARTNER_2);
   
   
   
   
   %Plot the RTs across subjects:
   %For Choice 1
   plot_RT__FOR_SELF_V_FOR_PARTNER_OVERALL(FOR_SELF, FOR_PARTNER);
   
   %For Choice 2
   plot_RT__FOR_SELF_V_FOR_PARTNER_OVERALL(FOR_SELF_2, FOR_PARTNER_2);
   
   
   
   
   %--------------------------------------------------------------------
   %For Part 3 - Comparing preference ratings
   %--------------------------------------------------------------------
   
   %Get the snack preferences
   [PREF_TASK_A] = pref_task_A(A);
   [PREF_TASK_B_SELF, PREF_TASK_B_PARTNER] = pref_self_vs_partner(B);
   
   
   %Plot the preferences
   plot_PREF__A_V_SELF_V_PARTNER(PREF_TASK_A, PREF_TASK_B_SELF, PREF_TASK_B_PARTNER)

   plot_PREF__A_V_SELF_V_PARTNER_OVERALL(PREF_TASK_A, PREF_TASK_B_SELF, PREF_TASK_B_PARTNER)
   
end



%Returns a 3D matrix: Think of it basically as a book,
%with each page corresponding to each subject.
%Only works for the Task B data
function [A_final, B_final] = return_matrix()
    for k=0:9
        
        %Will range from 9 to 18 (specific to this case)
        subject = 9+k; 
    
        %Format the numbers and get the files
        subject = sprintf('%03d',subject);
        file_str_task_A = strcat(subject, '_task_a_results.csv');
        file_str_task_B = strcat(subject, '_task_b_results.csv');
        
        
        %One page per subject
        A = readmatrix(file_str_task_A);
        B = readmatrix(file_str_task_B);
        
        for m=1:199
            for n=1:3
                A_final(m,n,k+1) = A(m,n);
            end
        end
        
        for i=1:180
            for j=1:13
                B_final(i,j,k+1) = B(i,j);
            end
        end        

    end
end



%Returns two lists; one with the "For Self" RTs,
%the other with the "For Partner" RTs.
%The row of each list represents a subject.
%The column of each list represents a trial.
function [FOR_SELF, FOR_PARTNER, FOR_SELF_2, FOR_PARTNER_2] = RT_self_vs_partner(M)

    trial_self = 1;
    trial_partner = 1;
    for subject=1:size(M,3)
        for row=1:180
            if(M(row, 12, subject) == 0)
                if(M(row, 13, subject) == 1)
                    if((~isnan(M(row, 6, subject)))  &&  (~isnan(M(row, 8, subject))))
                        FOR_SELF(subject, trial_self) = M(row, 6, subject);
                        FOR_SELF_2(subject, trial_self) = M(row, 8, subject);
                        trial_self = trial_self + 1;
                    end
                elseif(M(row, 13, subject) == 2)
                    if((~isnan(M(row, 6, subject)))  &&  (~isnan(M(row, 8, subject))))
                        FOR_PARTNER(subject, trial_partner) = M(row, 6, subject);
                        FOR_PARTNER_2(subject, trial_partner) = M(row, 8, subject);
                        trial_partner = trial_partner + 1;
                    end
                end
            end
           
        end
        trial_self=1;
        trial_partner=1;
    end
    
    FOR_SELF(FOR_SELF==0) = NaN;
    FOR_PARTNER(FOR_PARTNER==0) = NaN;
    
    FOR_SELF_2(FOR_SELF_2==0) = NaN;
    FOR_PARTNER_2(FOR_PARTNER_2==0) = NaN;
   
end



%Similarly, returns two lists,
%one with snack preference ratings for self-choices
%and one for partner-choices.
function [FOR_SELF_PREF, FOR_PARTNER_PREF] = pref_self_vs_partner(M)

    trial_self = 1;
    trial_partner = 1;
    for subject=1:size(M,3)
        for row=1:180
            if(M(row, 12, subject) == 0)
                if(M(row, 13, subject) == 1)
                    if((~isnan(M(row, 10, subject))))
                        FOR_SELF_PREF(subject, trial_self) = M(row, 10, subject);
                        trial_self = trial_self + 1;
                    end
                elseif(M(row, 13, subject) == 2)
                    if((~isnan(M(row, 10, subject))))
                        FOR_PARTNER_PREF(subject, trial_self) = M(row, 10, subject);
                        trial_partner = trial_partner + 1;
                    end
                end
            end
           
        end
        trial_self=1;
        trial_partner=1;
    end
    
    FOR_SELF_PREF(FOR_SELF_PREF==0) = NaN;
    FOR_PARTNER_PREF(FOR_PARTNER_PREF==0) = NaN;
   
end



%Returns a list for snack preferences from task A
function [PREF_TASK_A] = pref_task_A(M)

    trial_self = 1;
    for subject=1:size(M,3)
        for row=1:199
                if((~isnan(M(row, 2, subject))))
                    PREF_TASK_A(subject, trial_self) = M(row, 2, subject);
                    trial_self = trial_self + 1;
                end           
        end
        trial_self=1;
    end
    
    PREF_TASK_A(PREF_TASK_A==0) = NaN;
   
end



%Plots the "For Self" and "For Partner" RTs as lines
%with error bars, as needed (std errors)
function [] = plot_RT__FOR_SELF_V_FOR_PARTNER(FOR_SELF, FOR_PARTNER)
    

    %Get the averages
    MEANS_SELF = nanmean(FOR_SELF, 2);
    MEANS_PARTNER = nanmean(FOR_PARTNER, 2);
    MEANS_BOTH_SELF_AND_PARTNER = horzcat(MEANS_SELF, MEANS_PARTNER);

    
    %Find the std errors
    STDERRS_SELF = nanstd(FOR_SELF, 0, 2)/sqrt(return_size_without_nans_dim(FOR_SELF, 2));
    STDERRS_PARTNER = nanstd(FOR_PARTNER, 0, 2)/sqrt(return_size_without_nans_dim(FOR_PARTNER, 2));
    STDERRS_BOTH_SELF_AND_PARTNER = horzcat(STDERRS_SELF, STDERRS_PARTNER);
    
    %Plot effects for different subjects
    figure    
    for subject=1:size(MEANS_BOTH_SELF_AND_PARTNER, 1)
        er=errorbar(1:2, MEANS_BOTH_SELF_AND_PARTNER(subject, 1:2), STDERRS_BOTH_SELF_AND_PARTNER(subject, 1:2));
        rand_red = rand;
        rand_blue = rand;
        rand_green = rand;
        
        er.Color = [rand_red, rand_blue, rand_green];
        set(gca, 'XTick', 1:2, 'XTickLabel', {'For Self', 'For Partner'}, 'FontSize', 16);
        xlim([0.75, 2.25]);
        
        hold on
    end

end



%Plots the overall effect for self vs. partner on RT (cross-subject)
function [] = plot_RT__FOR_SELF_V_FOR_PARTNER_OVERALL(FOR_SELF, FOR_PARTNER)

    %Get the averages
    MEANS_SELF = nanmean(FOR_SELF, 2);
    MEANS_PARTNER = nanmean(FOR_PARTNER, 2);
    MEANS_BOTH_SELF_AND_PARTNER = horzcat(MEANS_SELF, MEANS_PARTNER);
    
    %Find the std errors
    STDERRS_SELF = nanstd(FOR_SELF, 0, 2)/sqrt(return_size_without_nans_dim(FOR_SELF, 2));
    STDERRS_PARTNER = nanstd(FOR_PARTNER, 0, 2)/sqrt(return_size_without_nans_dim(FOR_PARTNER, 2));
    STDERRS_BOTH_SELF_AND_PARTNER = horzcat(STDERRS_SELF, STDERRS_PARTNER);
    
    %Find the cross-subject average
    MEANS = nanmean(MEANS_BOTH_SELF_AND_PARTNER, 1);
    STDERRS = nanmean(STDERRS_BOTH_SELF_AND_PARTNER, 1);
    
    %Larger STDERR
     LARGER_STDERRS_SELF = nanstd(FOR_SELF, 0, 'all')/sqrt(return_size_without_nans(FOR_SELF));
     LARGER_STDERRS_PARTNER = nanstd(FOR_PARTNER, 0, 'all')/sqrt(return_size_without_nans(FOR_PARTNER));
     LARGER_STDERRS(1) = LARGER_STDERRS_SELF;
     LARGER_STDERRS(2) = LARGER_STDERRS_PARTNER;
    
    %Plot the figure
    figure
    bar(1:2,MEANS) 
    hold on
    er=errorbar(1:2,MEANS,LARGER_STDERRS);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    set(gca,'XTick',1:2,'XTickLabel',{'For Self', 'For Partner'}, 'FontSize', 16);

end



%Plots the preference ratings as line plots
%with error bars, as needed (std errors)
function [] = plot_PREF__A_V_SELF_V_PARTNER(PREF_TASK_A, PREF_TASK_B_SELF, PREF_TASK_B_PARTNER)
    
    %Get the averages
    MEANS_A = nanmean(PREF_TASK_A, 2);
    MEANS_SELF = nanmean(PREF_TASK_B_SELF, 2);
    MEANS_PARTNER = nanmean(PREF_TASK_B_PARTNER, 2);
    MEANS_ALL = horzcat(MEANS_A, MEANS_SELF, MEANS_PARTNER);

    
    %Find the std errors
    STDERRS_A = nanstd(PREF_TASK_A, 0, 2)/sqrt(return_size_without_nans_dim(PREF_TASK_A, 2));
    STDERRS_SELF = nanstd(PREF_TASK_B_SELF, 0, 2)/sqrt(return_size_without_nans_dim(PREF_TASK_B_SELF, 2));
    STDERRS_PARTNER = nanstd(PREF_TASK_B_PARTNER, 0, 2)/sqrt(return_size_without_nans_dim(PREF_TASK_B_PARTNER, 2));
    STDERRS_ALL = horzcat(STDERRS_A, STDERRS_SELF, STDERRS_PARTNER);
    
    %Plot effects for different subjects
    figure    
    for subject=1:size(MEANS_ALL, 1)
        er=errorbar(1:3, MEANS_ALL(subject, 1:3), STDERRS_ALL(subject, 1:3));
        rand_red = rand;
        rand_blue = rand;
        rand_green = rand;
        
        er.Color = [rand_red, rand_blue, rand_green];
        set(gca, 'XTick', 1:3, 'XTickLabel', {'Task A', 'Task B Self', 'Task B Partner'}, 'FontSize', 16);
        xlim([0.75, 3.25]);
        
        hold on
    end

end



%Plots the overall effect for preference rating (cross-subject)
function [] = plot_PREF__A_V_SELF_V_PARTNER_OVERALL(PREF_TASK_A, PREF_TASK_B_SELF, PREF_TASK_B_PARTNER)

    %Get the averages
    MEANS_A = nanmean(PREF_TASK_A, 2);
    MEANS_SELF = nanmean(PREF_TASK_B_SELF, 2);
    MEANS_PARTNER = nanmean(PREF_TASK_B_PARTNER, 2);
    MEANS_ALL = horzcat(MEANS_A, MEANS_SELF, MEANS_PARTNER);

    
    %Find the std errors
    STDERRS_A = nanstd(PREF_TASK_A, 0, 2)/sqrt(return_size_without_nans_dim(PREF_TASK_A, 2));
    STDERRS_SELF = nanstd(PREF_TASK_B_SELF, 0, 2)/sqrt(return_size_without_nans_dim(PREF_TASK_B_SELF, 2));
    STDERRS_PARTNER = nanstd(PREF_TASK_B_PARTNER, 0, 2)/sqrt(return_size_without_nans_dim(PREF_TASK_B_PARTNER, 2));
    STDERRS_ALL = horzcat(STDERRS_A, STDERRS_SELF, STDERRS_PARTNER);
        
    %Find the cross-subject average
    MEANS = nanmean(MEANS_ALL, 1);
    STDERRS = nanmean(STDERRS_ALL, 1);
    
    %Larger STDERR
     LARGER_STDERRS_A = nanstd(PREF_TASK_A, 0, 'all')/sqrt(return_size_without_nans(PREF_TASK_A));
     LARGER_STDERRS_SELF = nanstd(PREF_TASK_B_SELF, 0, 'all')/sqrt(return_size_without_nans(PREF_TASK_B_SELF));
     LARGER_STDERRS_PARTNER = nanstd(PREF_TASK_B_PARTNER, 0, 'all')/sqrt(return_size_without_nans(PREF_TASK_B_PARTNER));
     LARGER_STDERRS(1) = LARGER_STDERRS_A;
     LARGER_STDERRS(2) = LARGER_STDERRS_SELF;
     LARGER_STDERRS(3) = LARGER_STDERRS_PARTNER;
    
    %Plot the figure
    figure
    bar(1:3,MEANS) 
    hold on
    er=errorbar(1:3,MEANS,LARGER_STDERRS);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    set(gca,'XTick',1:3,'XTickLabel',{'Task A', 'Task B Self', 'Task B Partner'}, 'FontSize', 9);

end


%--------------------------------------------------------------------
%Below are just some auxilliary functions.
%--------------------------------------------------------------------
   
%Returns the number of elements in a 2D input matrix
function [size_without_nans] = return_size_without_nans(A)
    size_without_nans = 0;
    for i=1:size(A,1)
        for j=1:size(A,2)
            if(~isnan(A(i,j)))
                size_without_nans = size_without_nans + 1;
            end
        end
    end
end

%Returns the number of elements in an input matrix in a specified
%dimension
function [size_without_nans] = return_size_without_nans_dim(A, dim)
    size_without_nans = 0;
    
    if(dim == 1)
        for i=1:size(A,1)
            if(~isnan(A(i,1)))
                size_without_nans = size_without_nans + 1;
            end
        end
    elseif(dim == 2)
        for j=1:size(A,2)
            if(~isnan(A(1,j)))
                size_without_nans = size_without_nans + 1;
            end
        end
    end
end

