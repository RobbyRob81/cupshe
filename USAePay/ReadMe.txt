Easy WSDL

http://easywsdl.com


How to use generated classes:

1. Add all files from src folder to your iOS project. We recommend to create a separate group for these files in your XCode project.
2. Add all files from KissXML folder to your project.
3. Go to the project settings (choose "Edit Project Settings" from "Project" menu").
4. Go to the "Build" tab and make the following changes:
    In the "Linking" section, go to the "Other Linker Flags" section and add the value "-lxml2" (without quotes).
    In the "Search Paths" section add a new search path to the "Header Search Paths" for "/usr/include/libxml2" (needed for KissXML library)
5. Add all files from MIMEKit folder to your project
6. By default MTOM transfer is disabled. To enable it you should set EnableMTOM to true in your service class:
        service.EnableMTOM=TRUE;


USAePayueSoapServerBinding* service = [[USAePayueSoapServerBinding alloc]init];
[service MethodToInvoke];


Used libraries:

- KissXML (https://github.com/robbiehanson/KissXML)
- MIMEKit (https://bitbucket.org/BodyArchitect/mimekit) - this is a fork of MIMTKit which contains a few bug fixes.

Thanks for using EasyWsdl. We've spend much time to create this tool. We hope that it will simplify your development. If you like it, please upvote posts about it on stackoverflow and like us on Facebook (https://www.facebook.com/EasyWsdl).
This will help us promote the generator. If you find any problems then contact us and we will try to help you with your webservice.


Generator output:
1. Operation overrideTransaction has use attribute for output element set to "encoded" which is not fully supported
2. Operation overrideTransaction has use attribute for input element set to "encoded" which is not fully supported
3. Operation voidTransaction has use attribute for output element set to "encoded" which is not fully supported
4. Operation voidTransaction has use attribute for input element set to "encoded" which is not fully supported
5. Operation updateReceipt has use attribute for output element set to "encoded" which is not fully supported
6. Operation updateReceipt has use attribute for input element set to "encoded" which is not fully supported
7. Operation updateProductCategory has use attribute for output element set to "encoded" which is not fully supported
8. Operation updateProductCategory has use attribute for input element set to "encoded" which is not fully supported
9. Operation updateProduct has use attribute for output element set to "encoded" which is not fully supported
10. Operation updateProduct has use attribute for input element set to "encoded" which is not fully supported
11. Operation updateCustomerPaymentMethod has use attribute for output element set to "encoded" which is not fully supported
12. Operation updateCustomerPaymentMethod has use attribute for input element set to "encoded" which is not fully supported
13. Operation updateCustomer has use attribute for output element set to "encoded" which is not fully supported
14. Operation updateCustomer has use attribute for input element set to "encoded" which is not fully supported
15. Operation searchCustomersCustom has use attribute for output element set to "encoded" which is not fully supported
16. Operation searchCustomersCustom has use attribute for input element set to "encoded" which is not fully supported
17. Operation searchTransactionsCustom has use attribute for output element set to "encoded" which is not fully supported
18. Operation searchTransactionsCustom has use attribute for input element set to "encoded" which is not fully supported
19. Operation searchTransactionsCount has use attribute for output element set to "encoded" which is not fully supported
20. Operation searchTransactionsCount has use attribute for input element set to "encoded" which is not fully supported
21. Operation searchTransactions has use attribute for output element set to "encoded" which is not fully supported
22. Operation searchTransactions has use attribute for input element set to "encoded" which is not fully supported
23. Operation searchProductsCustom has use attribute for output element set to "encoded" which is not fully supported
24. Operation searchProductsCustom has use attribute for input element set to "encoded" which is not fully supported
25. Operation searchProductsCount has use attribute for output element set to "encoded" which is not fully supported
26. Operation searchProductsCount has use attribute for input element set to "encoded" which is not fully supported
27. Operation searchProducts has use attribute for output element set to "encoded" which is not fully supported
28. Operation searchProducts has use attribute for input element set to "encoded" which is not fully supported
29. Operation searchCustomersCount has use attribute for output element set to "encoded" which is not fully supported
30. Operation searchCustomersCount has use attribute for input element set to "encoded" which is not fully supported
31. Operation searchCustomers has use attribute for output element set to "encoded" which is not fully supported
32. Operation searchCustomers has use attribute for input element set to "encoded" which is not fully supported
33. Operation searchCustomerID has use attribute for output element set to "encoded" which is not fully supported
34. Operation searchCustomerID has use attribute for input element set to "encoded" which is not fully supported
35. Operation searchBatchesCount has use attribute for output element set to "encoded" which is not fully supported
36. Operation searchBatchesCount has use attribute for input element set to "encoded" which is not fully supported
37. Operation searchBatches has use attribute for output element set to "encoded" which is not fully supported
38. Operation searchBatches has use attribute for input element set to "encoded" which is not fully supported
39. Operation runTransactionAPI has use attribute for output element set to "encoded" which is not fully supported
40. Operation runTransactionAPI has use attribute for input element set to "encoded" which is not fully supported
41. Operation runTransaction has use attribute for output element set to "encoded" which is not fully supported
42. Operation runTransaction has use attribute for input element set to "encoded" which is not fully supported
43. Operation runCheckSale has use attribute for output element set to "encoded" which is not fully supported
44. Operation runCheckSale has use attribute for input element set to "encoded" which is not fully supported
45. Operation runSale has use attribute for output element set to "encoded" which is not fully supported
46. Operation runSale has use attribute for input element set to "encoded" which is not fully supported
47. Operation runAuthOnly has use attribute for output element set to "encoded" which is not fully supported
48. Operation runAuthOnly has use attribute for input element set to "encoded" which is not fully supported
49. Operation runQuickCredit has use attribute for output element set to "encoded" which is not fully supported
50. Operation runQuickCredit has use attribute for input element set to "encoded" which is not fully supported
51. Operation runQuickSale has use attribute for output element set to "encoded" which is not fully supported
52. Operation runQuickSale has use attribute for input element set to "encoded" which is not fully supported
53. Operation runCustomerTransaction has use attribute for output element set to "encoded" which is not fully supported
54. Operation runCustomerTransaction has use attribute for input element set to "encoded" which is not fully supported
55. Operation runCheckCredit has use attribute for output element set to "encoded" which is not fully supported
56. Operation runCheckCredit has use attribute for input element set to "encoded" which is not fully supported
57. Operation runCredit has use attribute for output element set to "encoded" which is not fully supported
58. Operation runCredit has use attribute for input element set to "encoded" which is not fully supported
59. Operation runBatchUpload has use attribute for output element set to "encoded" which is not fully supported
60. Operation runBatchUpload has use attribute for input element set to "encoded" which is not fully supported
61. Operation renderReceiptByName has use attribute for output element set to "encoded" which is not fully supported
62. Operation renderReceiptByName has use attribute for input element set to "encoded" which is not fully supported
63. Operation renderReceipt has use attribute for output element set to "encoded" which is not fully supported
64. Operation renderReceipt has use attribute for input element set to "encoded" which is not fully supported
65. Operation refundTransaction has use attribute for output element set to "encoded" which is not fully supported
66. Operation refundTransaction has use attribute for input element set to "encoded" which is not fully supported
67. Operation quickUpdateProduct has use attribute for output element set to "encoded" which is not fully supported
68. Operation quickUpdateProduct has use attribute for input element set to "encoded" which is not fully supported
69. Operation quickUpdateCustomer has use attribute for output element set to "encoded" which is not fully supported
70. Operation quickUpdateCustomer has use attribute for input element set to "encoded" which is not fully supported
71. Operation postAuth has use attribute for output element set to "encoded" which is not fully supported
72. Operation postAuth has use attribute for input element set to "encoded" which is not fully supported
73. Operation pauseBatchUpload has use attribute for output element set to "encoded" which is not fully supported
74. Operation pauseBatchUpload has use attribute for input element set to "encoded" which is not fully supported
75. Operation moveCustomer has use attribute for output element set to "encoded" which is not fully supported
76. Operation moveCustomer has use attribute for input element set to "encoded" which is not fully supported
77. Operation getTransactionStatus has use attribute for output element set to "encoded" which is not fully supported
78. Operation getTransactionStatus has use attribute for input element set to "encoded" which is not fully supported
79. Operation getTransactionReport has use attribute for output element set to "encoded" which is not fully supported
80. Operation getTransactionReport has use attribute for input element set to "encoded" which is not fully supported
81. Operation getTransactionCustom has use attribute for output element set to "encoded" which is not fully supported
82. Operation getTransactionCustom has use attribute for input element set to "encoded" which is not fully supported
83. Operation getTransaction has use attribute for output element set to "encoded" which is not fully supported
84. Operation getTransaction has use attribute for input element set to "encoded" which is not fully supported
85. Operation getSystemInfo has use attribute for output element set to "encoded" which is not fully supported
86. Operation getSystemInfo has use attribute for input element set to "encoded" which is not fully supported
87. Operation getSyncLogCurrentPosition has use attribute for output element set to "encoded" which is not fully supported
88. Operation getSyncLogCurrentPosition has use attribute for input element set to "encoded" which is not fully supported
89. Operation getSyncLog has use attribute for output element set to "encoded" which is not fully supported
90. Operation getSyncLog has use attribute for input element set to "encoded" which is not fully supported
91. Operation getSupportedCurrencies has use attribute for output element set to "encoded" which is not fully supported
92. Operation getSupportedCurrencies has use attribute for input element set to "encoded" which is not fully supported
93. Operation getReport has use attribute for output element set to "encoded" which is not fully supported
94. Operation getReport has use attribute for input element set to "encoded" which is not fully supported
95. Operation getReceipts has use attribute for output element set to "encoded" which is not fully supported
96. Operation getReceipts has use attribute for input element set to "encoded" which is not fully supported
97. Operation getReceiptByName has use attribute for output element set to "encoded" which is not fully supported
98. Operation getReceiptByName has use attribute for input element set to "encoded" which is not fully supported
99. Operation getReceipt has use attribute for output element set to "encoded" which is not fully supported
100. Operation getReceipt has use attribute for input element set to "encoded" which is not fully supported
101. Operation getProductInventory has use attribute for output element set to "encoded" which is not fully supported
102. Operation getProductInventory has use attribute for input element set to "encoded" which is not fully supported
103. Operation getProductCategories has use attribute for output element set to "encoded" which is not fully supported
104. Operation getProductCategories has use attribute for input element set to "encoded" which is not fully supported
105. Operation getProductCategory has use attribute for output element set to "encoded" which is not fully supported
106. Operation getProductCategory has use attribute for input element set to "encoded" which is not fully supported
107. Operation getProduct has use attribute for output element set to "encoded" which is not fully supported
108. Operation getProduct has use attribute for input element set to "encoded" which is not fully supported
109. Operation getCustomFields has use attribute for output element set to "encoded" which is not fully supported
110. Operation getCustomFields has use attribute for input element set to "encoded" which is not fully supported
111. Operation getCustomerReport has use attribute for output element set to "encoded" which is not fully supported
112. Operation getCustomerReport has use attribute for input element set to "encoded" which is not fully supported
113. Operation getCustomerPaymentMethods has use attribute for output element set to "encoded" which is not fully supported
114. Operation getCustomerPaymentMethods has use attribute for input element set to "encoded" which is not fully supported
115. Operation getCustomerPaymentMethod has use attribute for output element set to "encoded" which is not fully supported
116. Operation getCustomerPaymentMethod has use attribute for input element set to "encoded" which is not fully supported
117. Operation getCustomerHistory has use attribute for output element set to "encoded" which is not fully supported
118. Operation getCustomerHistory has use attribute for input element set to "encoded" which is not fully supported
119. Operation getCustomer has use attribute for output element set to "encoded" which is not fully supported
120. Operation getCustomer has use attribute for input element set to "encoded" which is not fully supported
121. Operation getCheckTrace has use attribute for output element set to "encoded" which is not fully supported
122. Operation getCheckTrace has use attribute for input element set to "encoded" which is not fully supported
123. Operation getBatchUploadStatus has use attribute for output element set to "encoded" which is not fully supported
124. Operation getBatchUploadStatus has use attribute for input element set to "encoded" which is not fully supported
125. Operation getBatchTransactions has use attribute for output element set to "encoded" which is not fully supported
126. Operation getBatchTransactions has use attribute for input element set to "encoded" which is not fully supported
127. Operation getBatchStatus has use attribute for output element set to "encoded" which is not fully supported
128. Operation getBatchStatus has use attribute for input element set to "encoded" which is not fully supported
129. Operation getBankList has use attribute for output element set to "encoded" which is not fully supported
130. Operation getBankList has use attribute for input element set to "encoded" which is not fully supported
131. Operation getAccountDetails has use attribute for output element set to "encoded" which is not fully supported
132. Operation getAccountDetails has use attribute for input element set to "encoded" which is not fully supported
133. Operation enableCustomer has use attribute for output element set to "encoded" which is not fully supported
134. Operation enableCustomer has use attribute for input element set to "encoded" which is not fully supported
135. Operation emailTransactionReceiptByName has use attribute for output element set to "encoded" which is not fully supported
136. Operation emailTransactionReceiptByName has use attribute for input element set to "encoded" which is not fully supported
137. Operation emailTransactionReceipt has use attribute for output element set to "encoded" which is not fully supported
138. Operation emailTransactionReceipt has use attribute for input element set to "encoded" which is not fully supported
139. Operation disableCustomer has use attribute for output element set to "encoded" which is not fully supported
140. Operation disableCustomer has use attribute for input element set to "encoded" which is not fully supported
141. Operation deleteReceipt has use attribute for output element set to "encoded" which is not fully supported
142. Operation deleteReceipt has use attribute for input element set to "encoded" which is not fully supported
143. Operation deleteProductCategory has use attribute for output element set to "encoded" which is not fully supported
144. Operation deleteProductCategory has use attribute for input element set to "encoded" which is not fully supported
145. Operation deleteProduct has use attribute for output element set to "encoded" which is not fully supported
146. Operation deleteProduct has use attribute for input element set to "encoded" which is not fully supported
147. Operation deleteCustomerPaymentMethod has use attribute for output element set to "encoded" which is not fully supported
148. Operation deleteCustomerPaymentMethod has use attribute for input element set to "encoded" which is not fully supported
149. Operation deleteCustomer has use attribute for output element set to "encoded" which is not fully supported
150. Operation deleteCustomer has use attribute for input element set to "encoded" which is not fully supported
151. Operation currencyConversion has use attribute for output element set to "encoded" which is not fully supported
152. Operation currencyConversion has use attribute for input element set to "encoded" which is not fully supported
153. Operation createBatchUpload has use attribute for output element set to "encoded" which is not fully supported
154. Operation createBatchUpload has use attribute for input element set to "encoded" which is not fully supported
155. Operation copyCustomer has use attribute for output element set to "encoded" which is not fully supported
156. Operation copyCustomer has use attribute for input element set to "encoded" which is not fully supported
157. Operation convertTranToCust has use attribute for output element set to "encoded" which is not fully supported
158. Operation convertTranToCust has use attribute for input element set to "encoded" which is not fully supported
159. Operation closeBatch has use attribute for output element set to "encoded" which is not fully supported
160. Operation closeBatch has use attribute for input element set to "encoded" which is not fully supported
161. Operation captureTransaction has use attribute for output element set to "encoded" which is not fully supported
162. Operation captureTransaction has use attribute for input element set to "encoded" which is not fully supported
163. Operation bulkCurrencyConversion has use attribute for output element set to "encoded" which is not fully supported
164. Operation bulkCurrencyConversion has use attribute for input element set to "encoded" which is not fully supported
165. Operation adjustInventory has use attribute for output element set to "encoded" which is not fully supported
166. Operation adjustInventory has use attribute for input element set to "encoded" which is not fully supported
167. Operation addReceipt has use attribute for output element set to "encoded" which is not fully supported
168. Operation addReceipt has use attribute for input element set to "encoded" which is not fully supported
169. Operation addProductCategory has use attribute for output element set to "encoded" which is not fully supported
170. Operation addProductCategory has use attribute for input element set to "encoded" which is not fully supported
171. Operation addProduct has use attribute for output element set to "encoded" which is not fully supported
172. Operation addProduct has use attribute for input element set to "encoded" which is not fully supported
173. Operation addCustomerPaymentMethod has use attribute for output element set to "encoded" which is not fully supported
174. Operation addCustomerPaymentMethod has use attribute for input element set to "encoded" which is not fully supported
175. Operation addCustomer has use attribute for output element set to "encoded" which is not fully supported
176. Operation addCustomer has use attribute for input element set to "encoded" which is not fully supported
