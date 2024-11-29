classdef projectionPlane < handle
    properties
        x (:, 1) double
        y (:, 1) double
        z (:, 1) double
        X
        Y
        Z
        sliderRotX
        sliderRotY
        sliderZ
        plano
        ax 
        fig 
        panel 
        projected_points
        proyeccion
    end
    
    methods
        function obj = projectionPlane(fig, ax, panel, x, y, z)
            %fig = figure('Name', 'Proyección de Puntos en un Plano', 'NumberTitle', 'off');
            obj.fig = fig;
            obj.ax = ax;
            obj.panel = panel;
            obj.x = x;
            obj.y = y;
            obj.z = z;
           
            %hold on;
            
            %title('Proyección de Puntos en un Plano');
        
            %scatter3(obj.ax, x, y, z, 36, 'filled');
        
            % tal vez toca cambiarlos por uislider y ponerles parent panel
            uicontrol(panel, 'Style', 'text', 'Position', [20 220 100 20], 'String', 'Rotación X');
            obj.sliderRotX = uicontrol(panel, 'Style', 'slider', 'Min', 0, 'Max', 360, 'Value', 0, ...
                                   'Position', [20 200 120 20], 'Callback', @(src, event) obj.actualizarPlano());
        
            uicontrol(panel, 'Style', 'text', 'Position', [20 180 100 20], 'String', 'Rotación Y');
            obj.sliderRotY = uicontrol(panel, 'Style', 'slider', 'Min', 0, 'Max', 360, 'Value', 0, ...
                                   'Position', [20 160 120 20], 'Callback', @(src, event) obj.actualizarPlano());
        
            uicontrol(panel, 'Style', 'text', 'Position', [20 140 100 20], 'String', 'Altura Plano (Z)');
            obj.sliderZ = uicontrol(panel, 'Style', 'slider', 'Min', -20, 'Max', 20, 'Value', 0, ...
                                'Position', [20 120 120 20], 'Callback', @(src, event) obj.actualizarPlano());
        
            uicontrol(panel, 'Style', 'pushbutton', 'String', 'Proyectar Puntos', ...
                      'Position', [20 80 120 30], 'Callback', @(src, event) obj.graficarProyeccion());
        
            % ???
            [obj.X, obj.Y] = meshgrid(-15:1:15, -15:1:15);
            obj.Z = zeros(size(obj.X));
            obj.plano = surf(obj.ax, obj.X, obj.Y, obj.Z, 'FaceAlpha', 0.5, 'EdgeColor', 'none');     
        end

        function actualizarPlano(obj)
            rotX = deg2rad(get(obj.sliderRotX, 'Value'));
            rotY = deg2rad(get(obj.sliderRotY, 'Value'));
            zOffset = get(obj.sliderZ, 'Value');
    
            Rz = [1 0 0; 0 cos(rotX) -sin(rotX); 0 sin(rotX) cos(rotX)];
            Ry = [cos(rotY) 0 sin(rotY); 0 1 0; -sin(rotY) 0 cos(rotY)];
            R = Ry * Rz;
    
            coords = [obj.X(:), obj.Y(:), zeros(numel(obj.X), 1)] * R';
            Xrot = reshape(coords(:,1), size(obj.X));
            Yrot = reshape(coords(:,2), size(obj.Y));
            Zrot = reshape(coords(:,3), size(obj.Z)) + zOffset;
    
            set(obj.plano, 'XData', Xrot, 'YData', Yrot, 'ZData', Zrot);
    
            % deberia proyectar nada mas despues de pulsar el boton
            % esto deberia ir adentro de graficarProyeccion
            normal = R(:, 3); 
            obj.projected_points = [];
            for i = 1:length(obj.x)
                point = [obj.x(i), obj.y(i), obj.z(i)];
                vector_to_point = point - [0, 0, zOffset];
                d = dot(normal, vector_to_point); 
    
                if d < 0 
                    projection = point - d * normal';
                    obj.projected_points = [obj.projected_points; projection];
                end
            end
    
            delete(obj.proyeccion);
            if ~isempty(obj.projected_points) 
                obj.proyeccion = scatter3(obj.ax, obj.projected_points(:,1), obj.projected_points(:,2), ...
                                      obj.projected_points(:,3), 36, 'r', 'filled');
            end
        end
    
        function graficarProyeccion(obj)
            if isempty(obj.projected_points)
                return; 
            end
            figure('Name', 'Puntos Proyectados', 'NumberTitle', 'off');
            scatter3(obj.ax, obj.projected_points(:,1), obj.projected_points(:,2), ...
                     obj.projected_points(:,3), 36, 'b', 'filled');
            %grid on;
            %axis equal;
            %xlabel('X'); ylabel('Y'); zlabel('Z');
            %title('Puntos Proyectados en el Plano');
        end
    end
end