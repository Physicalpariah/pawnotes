

public func GetBG(isDarkMode: Bool, background:Int) -> String {
    
    var bgName = "bg-"
    
    switch background
    {
    case (0):
        do {
            bgName += "ruled"
        }
    case (1):
        do {
            bgName += "dots"
        }
    case (2):
        do {
            bgName += "none"
        }
    default:
        bgName += "ruled"
    }
    
    var resourceName = bgName + "-light.jpg"
    if isDarkMode {
        resourceName = bgName + "-dark.jpg"
    }
    
    return resourceName
}
