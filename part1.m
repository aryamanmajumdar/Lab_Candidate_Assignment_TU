%------------------------------------
%TU Application Exercise
%Aryaman Majumdar
%------------------------------------
function[FS, FP] = part1()

   %Get all the data in a matrix
   M = return_matrix(); 
   
   %Get the response times from the data matrix
   [FOR_SELF, FOR_PARTNER] = RT_self_vs_partner(M);
   
   %Plot the response times
   plot_RT__FOR_SELF_V_FOR_PARTNER(FOR_SELF, FOR_PARTNER);
   
end

%Returns a 3D matrix: Think of it basically as a book,
%with each page corresponding to each subject.
%Only works for the Task B data
function [M] = return_matrix()
    for k=0:9
        
        %Will range from 9 to 18 (specific to this case)
        subject = 9+k; 
    
        %Format the numbers and get the files
        subject = sprintf('%03d',subject);         
        file_str = strcat(subject, '_task_b_results.csv');
        
        %One page per subject
        A = readmatrix(file_str);
        
        
        for i=1:180
            for j=1:13
                M(i,j,k+1) = A(i,j);
            end
        end
    end
end

%Returns two lists; one with the "For Self" RTs,
%the other with the "For Partner" RTs.
function [FOR_SELF, FOR_PARTNER] = RT_self_vs_partner(M)

    for subject=1:size(M,3)
        for row=1:180
            if( (M(row, 1, subject) == 1) || (M(row, 1, subject) == 2) )
                if(~isnan(M(row, 6, subject)))
                    FOR_SELF(subject+row) = M(row, 6, subject); 
                end
            elseif( (M(row, 1, subject) == 5) || (M(row, 1, subject) == 6))
                if(~isnan(M(row, 6, subject)))
                    FOR_PARTNER(subject+row) = M(row, 6, subject);
                end
            end
            
        end
    end
    
end

%Plots the "For Self" and "For Partner" RTs as bars
%with error bars, as needed (std errors)
function [] = plot_RT__FOR_SELF_V_FOR_PARTNER(FOR_SELF, FOR_PARTNER)
    
    %Get the averages
    MEANS(1) = mean(FOR_SELF);
    MEANS(2) = mean(FOR_PARTNER);
    
    %Find the std errors
    STDERR(1) = std(FOR_SELF)/sqrt(length(FOR_SELF));
    STDERR(2) = std(FOR_PARTNER)/sqrt(length(FOR_PARTNER));
    
    %Plot the figure
    figure
    bar(1:2,MEANS) 
    hold on
    er=errorbar(1:2,MEANS,STDERR);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    set(gca,'XTick',1:2,'XTickLabel',{'For Self', 'For Partner'}, 'FontSize', 16);
end


