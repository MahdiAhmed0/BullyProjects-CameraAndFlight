# مشروع بـ لعبة: شغب في مدارس لندن

## وصف المشروع: التحكم بالكاميرا والطيران

المشروع هذا تمت كتابته لأجل تطبيق عدّة نظريات تخص الـ 3D Space في الرياضيات والفيزياء بشكل عام.
المشروع تم تطويره من قبل derpy54320, تم إعادة صياغة وكتابة الكود البرمجي من قبل Fibonacci. 
في هذي الصفحة راح اناقش كيف تعمل الكاميرا والتحرك بها وباللاعب بـ أستخدام لعبة Bully ولغتها البرمجية Lua,
السكربت يستطيع ان يجعل اللاعب يطير أي مكان ويحرك الكاميرا أي مكان.



# حساب التحركات

## 2D Space: Player Movement

عشان نفهم شلون السكربت يشتغل... لدينا في السكربت عدّة متغيرات خاصة بحساب الـ 2D&3D Forward Direction

#### local cp = camera pitch

#### local ch = camera heading (in radians)

#### local dist = distance (adjusts the camera's distance from the player)


بعد ماعرفنا وش ترمز له المتغيرات, الأن خلنا نشرح function F_GetForwardDir2D

وظيفة الفنكشن هي حساب الاتجاهات الأمامية في نظام ثنائي الأبعاد, بأستخدام الـ heading والي تكون قيمته بـ الـ radians
وأيضاً الـ distance.

* x = -sin(h) ⋅ dist
* y = cos(h) ⋅ dist


عشان نفهم ليش أخترنا هالمتغيرات بالضبط... اول شي لازم نشرح ما هو الـ Vector

تعريف الـ Vector:
مصطلح يستخدموه العلماء للأشارة الى كمّية (زي الأزاحة او السرعة او القوة) وتحمل قيمتان, حجم (magnitude) واتجاه (direction).
وعلى الأغلب عشان نرسمها, نستخدم السهم عشان يشير الى اتجاه, ويحمل حجم.

<img width="100" alt="Screenshot_122" src="https://github.com/MahdiAhmed0/BullyProjects-CameraAndFlight/assets/143342068/cd8045e1-581e-495e-ad38-a8bc8e136442">



طيب نرجع لـ الدالة, هنا الـ Vector حقنا عبارة عن قيمتان, الـ  Heading و Distance,
الـ Heading تمثل الاتجاه, بينما الـ Distance يمثل الحجم او القيمة للحركة.

بأستخدام المعادلة الي شرحناها فوق, ناتجها راح يكون قيمتان وهي x و y
بمعناه ان الدالة او الفنكشن راح يرجع قيمتان.

بعد ماتعلمنا الفكرة والنظرية... طبقناها في السكربت بـ اننا نأخذ Two Vectors

#### local x1, y1 = F_GetForwardDir2D(ch, GetStickValue(17, 0) / 10 * speed)

#### local x2, y2 = F_GetForwardDir2D(ch + math.pi / 2, GetStickValue(16, 0) / 10 * speed)

الـمتغيرين x1, y1 راح يطلع لنا Vector خاص بأتجاه اللاعب, بينما الأخر x2, y2 راح يطلع لنا الأتجاهات العامودية على اتجاهات الـ Vector الأول.
الـ Vector الأول خاص بالحركة الى الأمام والثاني خاص بالحركة العامودية.
* ch: The current heading of the player.
* GetStickValue(17, 0) / 10 * speed: The magnitude of the forward movement.
* ch + math.pi / 2: The heading perpendicular to the current heading.
* GetStickValue(16, 0) / 10 * speed: The magnitude of the perpendicular movement.


## 3D Space: Camera Position

الأن بنشرح فنكشن الـ function F_GetForwardDir3D
هذي الدالة خاصة فقط بـ الكاميرا, تحركاتها وتوجيهاتها.

الفنكشن يحسب الأتجاهات الأمامية في الـ 3D Space اعتماداً على عدّة متغيرات

#### p = pitch (in radians)

#### h = heading (in radians)

#### dist = distance

معنى هذي المتغيرات هي:
#### Pitch = الزاوية الرأسية

#### Heading = الزاوية الأفقية

#### Distance = حجم او كمية الحركة

الفنكشن راح يرجع x, y, z والي هو الـ Vecotr الخاص بالكاميرا في نظام ثلاثي الأبعاد.

* x = cos(p) ⋅ −sin(h) ⋅ dist
* y = cos(p) ⋅ cos(h) ⋅ dist
* z = sin(p) ⋅ dist

تطبيقها في السكربت:

#### local cx, cy, cz = F_GetForwardDir3D(cp, ch, -dist * 0.04)


#### cp = current camera pitch

#### ch = current camera heading

#### -dist * 0.04 = distance from the player to the camera

لو نلاحظ هنا ان الـ dist مخلينه سالب, والسبب يعود الى ان الكاميرا خلف اللاعب وليست أمام اللاعب.
الناتج النهائي هو ثلاث قيّم cx, cy, cz والي تعني ازاحة الكاميرا او مكان الكاميرا من اللاعب.

## مفاهيم رياضية

نستخدم علم المثلثات او Trigonometry في حساباتنا, لأنها قابلة من ان تحول الزواية والأحجام الى Direction Vectors
وهذا تكنيك معروف ومستخدم في تطوير الألعاب.


باقي الكود عبارة عن تزبيط وتشغيل النظريات الي طبقناها, فلذالك لم اشرحها.


## Credits

* Fibonacci - Rewriting the Equations and Code
* derpy54320 - Developing and Applying Mathematical Concepts in Bully
