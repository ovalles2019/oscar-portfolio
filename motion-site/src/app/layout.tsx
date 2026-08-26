import type { Metadata } from "next";
import { Inter } from "next/font/google";
import SiteChat from "@/components/site-chat";
import Navbar from "@/components/navbar";
import BackToTop from "@/components/back-to-top";
import { ThemeProvider } from "@/components/theme-provider";
import "./globals.css";

const inter = Inter({
  variable: "--font-sans",
  subsets: ["latin"],
  weight: ["400", "500", "600", "700", "800"],
});

export const metadata: Metadata = {
  title: "Oscar Valles — Cloud Engineer & Full-Stack Developer",
  description:
    "Portfolio of Oscar Valles. Building production-grade cloud systems, AI infrastructure, and scalable applications.",
};

const themeBoot = `(function(){try{var t=localStorage.getItem('theme');if(t==='light'){document.documentElement.setAttribute('data-theme','light');document.documentElement.classList.remove('dark');}else{document.documentElement.setAttribute('data-theme','dark');document.documentElement.classList.add('dark');}}catch(e){}})();`;

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className={`${inter.variable} dark`} suppressHydrationWarning>
      <head>
        <script dangerouslySetInnerHTML={{ __html: themeBoot }} />
      </head>
      <body className="min-h-screen bg-[var(--bg)] text-[var(--text-primary)] font-sans antialiased">
        <ThemeProvider>
          <Navbar />
          {children}
          <BackToTop />
          <SiteChat />
        </ThemeProvider>
      </body>
    </html>
  );
}
