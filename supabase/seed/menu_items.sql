INSERT INTO public.menu_items (name, price, image_url, description, is_available) VALUES
  ('Espresso',          45.00,  NULL, 'เอสเพรสโซช็อตเข้มข้น กลิ่นหอมเต็มเปี่ยม', true),
  ('Americano',         55.00,  NULL, 'อเมริกาโน่ เอสเพรสโซเติมน้ำร้อน รสชาติกลมกล่อม', true),
  ('Latte',             65.00,  NULL, 'ลาเต้ เอสเพรสโซผสมนมสดร้อน หอมนุ่มละมุน', true),
  ('Cappuccino',        65.00,  NULL, 'คาปูชิโน่ เอสเพรสโซ นมสด และฟองนมเนียนนุ่ม', true),
  ('Mocha',             75.00,  NULL, 'มอคค่า เอสเพรสโซผสมช็อกโกแลตและนมสด', true),
  ('Caramel Macchiato', 80.00,  NULL, 'คาราเมลมัคคิอาโต้ นมสด เอสเพรสโซ ราดซอสคาราเมล', true),
  ('Matcha Latte',      70.00,  NULL, 'มัทฉะลาเต้ ชาเขียวมัทฉะแท้ผสมนมสด', true),
  ('Thai Tea',          55.00,  NULL, 'ชาไทย ชาแดงสูตรเข้มข้นผสมนมข้นหวาน', true),
  ('Iced Coffee',       50.00,  NULL, 'กาแฟเย็น เอสเพรสโซเย็นผสมนมสดและน้ำเชื่อม', true),
  ('Hot Chocolate',     65.00,  NULL, 'ฮอตช็อกโกแลต ช็อกโกแลตเข้มข้นผสมนมร้อน', true),
  ('Green Tea Frappe',  75.00,  NULL, 'กรีนทีแฟรปเป้ ชาเขียวปั่นเย็นสดชื่น', true),
  ('Cocoa Smoothie',    70.00,  NULL, 'โกโก้สมูทตี้ โกโก้ปั่นเย็นหอมหวาน', true),
  ('Vanilla Latte',     70.00,  NULL, 'วนิลาลาเต้ เอสเพรสโซผสมนมสดและไซรัปวนิลา', true),
  ('Honey Lemon Tea',   55.00,  NULL, 'ชามะนาวน้ำผึ้ง ชาอุ่นผสมน้ำมะนาวและน้ำผึ้งแท้', true),
  ('Dirty Coffee',      70.00,  NULL, 'เดอร์ตี้คอฟฟี่ เอสเพรสโซราดบนนมสดเย็น', true)
ON CONFLICT DO NOTHING;
