# دليل المصادقة التقني (NotebookLM Authentication Guide)

## المصادقة التلقائية (CLI Mode)
هي الطريقة الأسرع وتعتمد على فتح متصفح Chrome للقيام بعملية الدخول وحفظ الملفات في `~/.notebooklm-mcp/auth.json`.

**الأمر**:
```powershell
py -m notebooklm_mcp.auth_cli
```

## المصادقة اليدوية (Cookie Extraction)
استخدم هذه الطريقة إذا فشلت الطريقة التلقائية أو إذا كنت تعمل في بيئة لا تدعم فتح المتصفح.

1.  افتح [notebooklm.google.com](https://notebooklm.google.com).
2.  افتح أدوات المطور (F12) وانتقل إلى تبويب **Network**.
3.  ابحث عن طلب باسم `batchexecute`.
4.  قم بنسخ قيمة `cookie` من الـ Headers.
5.  استخدم أداة `mcp_notebooklm_save_auth_tokens` لتخزينها.

## رسالة طلب الكوكيز اليدوي (Manual Cookie Request Prompt)
في حال فشل عملية المصادقة الآلية، استخدم النص التالي لطلب البيانات من المستخدم:

> "The NotebookLM MCP server installation failed or the automatic authentication script (notebooklm-mcp-auth) could not open the browser. To proceed, we need your NotebookLM session cookies manually. Please follow these steps:
> 1. Open Chrome and go to [notebooklm.google.com](https://notebooklm.google.com).
> 2. Press **F12** to open Developer Tools.
> 3. Go to the **Network** tab and refresh the page.
> 4. Find any request (like `batchexecute`), right-click it, and select **Copy > Copy as cURL (bash)**.
> 5. Paste the value of the `cookie:` header here."

## حل المشكلات (Troubleshooting)

### RPC Error 16: Authentication expired
هذا يعني أن الجلسة انتهت. الحل هو:
1.  محاولة `mcp_notebooklm_refresh_auth`.
2.  إذا لم ينجح، نفذ المصادقة التلقائية مجدداً.

### Package Not Found
تأكد من استخدام `py -m` لضمان الوصول للمكتبة إذا لم تكن في المسار العام (PATH):
`py -m notebooklm_mcp.server`
