﻿using System.Text;
using System.Xml;
using NUnit.Framework;
using SpainHoliday.SepaWriter.Utils;

namespace SpainHoliday.SepaWriter.Test.Utils
{
    [TestFixture]
    public class XmlUtilsTest
    {
        [Test]
        public void ShouldCreateXmlBicForAProvidedBic()
        {
            var xml = new XmlDocument();
            xml.AppendChild(xml.CreateXmlDeclaration("1.0", Encoding.UTF8.BodyName, "yes"));
            var el = (XmlElement)xml.AppendChild(xml.CreateElement("Document"));

            XmlUtils.CreateBic(el, new SepaIbanData { Bic="01234567" });
            Assert.AreEqual("<FinInstnId><BIC>01234567</BIC></FinInstnId>", el.InnerXml);
        }

        [Test]
        public void ShouldCreateXmlUnknownBicForAnUnknwonBic()
        {
            var xml = new XmlDocument();
            xml.AppendChild(xml.CreateXmlDeclaration("1.0", Encoding.UTF8.BodyName, "yes"));
            var el = (XmlElement)xml.AppendChild(xml.CreateElement("Document"));

            XmlUtils.CreateBic(el, new SepaIbanData { UnknownBic = true});
            Assert.AreEqual("<FinInstnId><BIC><Othr><Id>NOTPROVIDED</Id></Othr></BIC></FinInstnId>", el.InnerXml);
        }
    }
}