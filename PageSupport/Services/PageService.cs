using System;
using System.IO;
using System.Net;

namespace PageSupport.Services
{
    public class PageService
    {
        public bool IsUrlValid(string url)
        {
            Uri validatedUri;
            bool result = false;
            if (Uri.TryCreate(url, UriKind.Absolute, out validatedUri))
            {
                result = (validatedUri.Scheme == Uri.UriSchemeHttp || validatedUri.Scheme == Uri.UriSchemeHttps);
            }
            else return false;

            WebRequest request = WebRequest.Create(url);
            try
            {
                request.GetResponse();
                result = true;
            }
            catch
            {
                result = false;
            }
            return result;
        }

        public string GetPageHtml(string url)
        {
            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                request.AutomaticDecompression = DecompressionMethods.GZip;
                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())

                using (Stream stream = response.GetResponseStream())
                using (StreamReader reader = new StreamReader(stream))
                {
                    return reader.ReadToEnd();
                }

            }
            catch (Exception ex)
            {
                SimpleLogger.Logger.Log(ex);
                throw new NotImplementedException();
            }
        }
    }
}