http.cache.disable();
$path = http.getpath(); 

if( string.contains( $path, '/images/') && ! http.getQueryString() && http.getMethod() == "GET"){ 
   http.cache.enable(); 
} 