function [handleNext] = selectPoints(fig)
    pts = [];
    function [new_pts, ended] = nextSelect(fig)
        %datacursormode on
        dcm_obj = datacursormode(fig);
        f = [];
        ended = false;
        while isempty(f)
            old_char = fig.CurrentCharacter;
            uiwait(fig)
            new_char = fig.CurrentCharacter;
            if old_char ~= new_char % if user presses a key
                ended = true;
                break
            end
            f = getCursorInfo(dcm_obj);
        end
        new_pts = [pts; f.Position];
        pts = new_pts;
        delete(findall(fig,'Type','hggroup'));
    end
    
    handleNext = @() nextSelect(fig);
    
end
