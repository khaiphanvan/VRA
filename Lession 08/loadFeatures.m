function data = loadFeatures(strFileName, environmentName)
    tmp = load(strFileName);
    data = tmp.(environmentName);
end