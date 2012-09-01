function get_cookie(name)
{
  with(document.cookie)
  {
    var regexp=new RegExp("(^|;\\s+)"+name+"=(.*?)(;|$)");
    var hit=regexp.exec(document.cookie);
    if(hit&&hit.length>2) return unescape(hit[2]);
    else return '';
  }
};

function set_cookie(name,value,days)
{
  if(days)
  {
    var date=new Date();
    date.setTime(date.getTime()+(days*24*60*60*1000));
    var expires="; expires="+date.toGMTString();
  }
  else expires="";
  document.cookie=name+"="+value+expires+"; path=/";
}

function get_password(name)
{
  var pass=get_cookie(name);
  if(pass) return pass;

  var chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  var pass='';

  for(var i=0;i<8;i++)
  {
    var rnd=Math.floor(Math.random()*chars.length);
    pass+=chars.substring(rnd,rnd+1);
  }

  return(pass);
}