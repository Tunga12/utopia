
class Util {

    static String urlToPath(String url){

        var decodedURL = Uri.decodeComponent(Uri.decodeComponent(url));
        var firstPartRemoved = decodedURL.substring(decodedURL.indexOf('/o/')).replaceAll('/o/', '');
        var path = firstPartRemoved.substring(0, firstPartRemoved.indexOf('?')).replaceAll('?', '');
        
        return path;
    }
}