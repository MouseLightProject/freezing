function result = dir_without_dot_and_dot_dot(path)
    % Like dir(), but result does not include '.' and '..'.
    if ~exist('path', 'var') || isempty(path) ,
        path = pwd() ;
    end
    raw_result = dir(path) ;
    is_dot_or_dot_dot = ismember({raw_result.name}, {'.', '..'}) ;
    result = raw_result(~is_dot_or_dot_dot);
end
