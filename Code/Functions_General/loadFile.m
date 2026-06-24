function variable = loadFile(filename)
    variable = load(filename);
    nameOfVar = fields(variable);
    nameOfVar = nameOfVar{1};
    variable = variable.(nameOfVar);
end