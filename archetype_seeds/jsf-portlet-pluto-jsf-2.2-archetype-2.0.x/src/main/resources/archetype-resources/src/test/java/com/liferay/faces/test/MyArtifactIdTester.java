package com.liferay.faces.test;

import static org.junit.Assert.assertTrue;

import java.util.logging.Level;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.gargoylesoftware.htmlunit.BrowserVersion;
import com.gargoylesoftware.htmlunit.WebClient;
import com.gargoylesoftware.htmlunit.html.HtmlAnchor;
import com.gargoylesoftware.htmlunit.html.HtmlDivision;
import com.gargoylesoftware.htmlunit.html.HtmlPage;
import com.gargoylesoftware.htmlunit.html.HtmlPasswordInput;
import com.gargoylesoftware.htmlunit.html.HtmlSubmitInput;
import com.gargoylesoftware.htmlunit.html.HtmlTextInput;


public class MyArtifactIdTester {

	private String guestUrl = "http://localhost:8080/pluto/portal";
	private String url;

	private WebClient webClient;

	@Test
	public void myArtifactIdTest() throws Exception {

		url = guestUrl + "/arch";

		HtmlPage initialPage = webClient.getPage(url);
		webClient.waitForBackgroundJavaScript(100);

		String magic = "Hello myArtifactId!";
		String panelXpath = "//div[contains(@id,':panelId')]";

		HtmlDivision div = initialPage.getFirstByXPath(panelXpath);
		assertTrue("There should be a div on the page with an id that contains ':panelId', but there is no such div.",
			div != null);

		System.out.println("div.getTextContent() = " + div.getTextContent());
		assertTrue("div should contain text '" + magic + "', but contains '" + div.getTextContent() + "'",
			div.getTextContent().contains(magic));

	}

	@After
	public void tearDown() {
		webClient.close();
	}

	@Before
	public void setUp() throws Exception {
		webClient = new WebClient(BrowserVersion.FIREFOX_38);
		webClient.getOptions().setJavaScriptEnabled(true);
		java.util.logging.Logger.getLogger("com.gargoylesoftware.htmlunit").setLevel(Level.OFF);

		url = guestUrl + "/arch";
		HtmlPage initialPage = webClient.getPage(url);
		webClient.waitForBackgroundJavaScript(100);

		String usernameXpath = "//input[@id='j_username']";
		String passwordXpath = "//input[@id='j_password']";
		String loginXpath = "//input[@id='j_login']";
		String logoutXpath = "//div[@id='logout']/a";

		HtmlTextInput username = initialPage.getFirstByXPath(usernameXpath);
		HtmlPasswordInput password = initialPage.getFirstByXPath(passwordXpath);
		HtmlSubmitInput login = initialPage.getFirstByXPath(loginXpath);
		HtmlAnchor logoutAnchor = initialPage.getFirstByXPath(logoutXpath);

		if (username != null) {
			username.type("pluto");
			password.type("pluto");
		}

		if (login != null) {
			HtmlPage pageAfterSubmit = (HtmlPage) login.click();
			webClient.waitForBackgroundJavaScriptStartingBefore(100);

			logoutAnchor = pageAfterSubmit.getFirstByXPath(logoutXpath);
			if (logoutAnchor != null) {
				System.out.println("logoutAnchor.getTextContent() = " + logoutAnchor.getTextContent());
			}
		}

	}

}

