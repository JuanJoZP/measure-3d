function [handleNext] = selectPoints(app)
    pts = [];
    function [new_pts, ended] = nextSelect(app)
        tth = findall(app.plot_axis,'Type','hggroup');     % find any pre-existing data tips
        delete(tth)    
        tth = [];
        ended = false;
        while isempty(tth)
            uiwait(app.UIFigure)
            disp("resumed")
            if strcmp(app.resumeSource, 'keypress')
                ended = true;
                new_pts = pts;
                return
            end
            tth = findall(app.plot_axis,'Type','hggroup');
            disp(tth)
            pos = tth.Position;
            pause(0.1)
        end
        new_pts = [pts; pos];
        pts = new_pts;
    end
    
    handleNext = @() nextSelect(app);
    
end
