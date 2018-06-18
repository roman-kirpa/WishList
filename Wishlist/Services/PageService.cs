using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;

namespace Wishlist.Services
{
    public class PageService
    {
        public bool ValidUrl(string url)
        {
            Uri validatedUri;

            if (Uri.TryCreate(url, UriKind.Absolute, out validatedUri)) //.NET URI validation.
            {
                //If true: validatedUri contains a valid Uri. Check for the scheme in addition.
                return (validatedUri.Scheme == Uri.UriSchemeHttp || validatedUri.Scheme == Uri.UriSchemeHttps);
            }
            return false;
        }

        public string GetPageHtml(string url)
        {
            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                request.AutomaticDecompression = DecompressionMethods.GZip;
                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                    if (response.StatusCode.ToString() == "OK")
                    {
                        using (Stream stream = response.GetResponseStream())
                        using (StreamReader reader = new StreamReader(stream))
                        {
                            return reader.ReadToEnd();
                        }
                    }
                    else
                    {
                        return "somthing wrong with url";
                    }
            }
            catch(Exception ex)
            {
                return "somthing wrong with url";
            }
                
        }
    }
}