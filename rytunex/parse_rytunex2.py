import re, json, os
# Build full catalog
tags_path = []
for xaml in [r'C:\Users\LENOVO\rytunex\Views\OptimizeSystemPage.xaml', r'C:\Users\LENOVO\rytunex\Views\PrivacyPage.xaml']:
    txt=open(xaml,encoding='utf-8',errors='ignore').read()
    tags_path.extend(re.findall(r'Tag="([^"]+)"', txt))
# unique
tags = sorted(set([t for t in tags_path if t not in ["Default","Disabled","Manually","Security"]]))
# OptimizeSystemHelper bases
helper=r'C:\Users\LENOVO\rytunex\Helpers\OptimizeSystemHelper.cs'
htxt=open(helper,encoding='utf-8',errors='ignore').read()
bases=sorted(set(re.findall(r'public static async Task (?:Disable|Enable)(\w+)\(', htxt)))
# Intelligent engine tags (only 14 but subset)
# Full view tags 101 as counted via powershell - let's use 101
full_tags = []
for fn in [r'C:\Users\LENOVO\rytunex\Views\OptimizeSystemPage.xaml', r'C:\Users\LENOVO\rytunex\Views\PrivacyPage.xaml', r'C:\Users\LENOVO\rytunex\Views\FeaturesPage.xaml', r'C:\Users\LENOVO\rytunex\Views\SecurityPage.xaml']:
    if os.path.exists(fn):
        txt=open(fn,encoding='utf-8',errors='ignore').read()
        full_tags.extend(re.findall(r'Tag="([^"]+)"', txt))
full_unique=sorted(set([t for t in full_tags if t not in ["Default","Disabled","Manually","Security","All","Standard","Win32"]]))
# Build catalog entry per base with risk guess from file existence
# For this snoop we list bases + tags
data={'source':'rayenghanmi/RyTuneX 5.3k WinUI3','method':'Views/*.xaml Tag + Helpers/OptimizeSystemHelper.cs Disable/Enable pairs','total_toggle_bases':len(bases),'total_xaml_tags':len(full_unique),'bases':bases,'xaml_tags':full_unique,'optimize_toggles':sorted(set(re.findall(r'Tag="([^"]+)"', open(r'C:\Users\LENOVO\rytunex\Views\OptimizeSystemPage.xaml',encoding='utf-8',errors='ignore').read()))) ,'privacy_toggles':sorted(set(re.findall(r'Tag="([^"]+)"', open(r'C:\Users\LENOVO\rytunex\Views\PrivacyPage.xaml',encoding='utf-8',errors='ignore').read())))}
open(r'C:\Users\LENOVO\tweak-snoop\rytunex\CATALOG.json','w',encoding='utf-8').write(json.dumps(data,indent=2))
print('bases',len(bases),'tags',len(full_unique),len(tags))
print(bases[:10])
