classdef TheClaw < Orion5
    %TheClaw a Class to be used by EGB339 students
    %   TheClaw inherits all of Orion5 class refer documentation for
    %   details
    
    properties
        % define global properties of TheClaw here
        
        %offsets in the base of the robot
        OFFSET_R = 0.030309;
        OFFSET_Z = 0.053;
        
        %link lengths for the orion5
        LINK_1 = 0.170384;
        LINK_2 = 0.136307;
        LINK_3 = 0.11;
        
        %JOINT_ANGLES used to keep track of the robots angles converted
        %from joint space
        JOINT_ANGLES = nan;
        
        % DES_JOINT_ANGLES modified to suite robot i.e. scaled
        % for gearboxes and the like and should not be used for current
        % angles
        DES_JOINT_ANGLES = nan;
        
        
        JOINT_OFFSET = [0, 0, 180, 180, 0];
        
        GEAR_RATIOS = [1, 2.857, 1, 1, 1];        
    end
    
    methods
        function obj = TheClaw()
            obj@Orion5();
        end
        
        function grasp(obj)
            %Modify this function to convert the desired width of the
            %gripper to the required angular position of for the gripper.
            %Check the joint limits and returning an error if they
            %are exceeded.
            error('This function needs to be implemented')            
        end
        
        function forward_kinematics(obj)
            %Modify this function to caculate the tooltip location based on
            %the current joint state of the robot. 
            error('This function needs to be implemented')
        end
        
        function inverse_kinematics(obj)
            %Modify this function to calculate the desired joint states to achieve the desired tooltip location 
            error('This function needs to be implemented')
        end
    end
end
 


