USE qiming_bbs;

UPDATE bbs_categories
SET name = '元老院公告', description = '论坛规则、公共通知、重要决议和管理员公告', sort_order = 10, status = 'ACTIVE'
WHERE slug = 'senate' OR id = 1;

UPDATE bbs_categories
SET name = '工业建设', description = '机械、冶金、化工、电力、制造与基础设施方案', sort_order = 20, status = 'ACTIVE'
WHERE slug = 'industry' OR id = 2;

UPDATE bbs_categories
SET name = '农业与物资', description = '粮食、种植、畜牧、仓储、后勤和物资调配', sort_order = 30, status = 'ACTIVE'
WHERE slug = 'agriculture' OR id = 3;

UPDATE bbs_categories
SET name = '医疗卫生', description = '疾病防治、药品、公共卫生、急救和检疫事务', sort_order = 40, status = 'ACTIVE'
WHERE slug = 'medicine' OR id = 4;

UPDATE bbs_categories
SET name = '军务安保', description = '营地防卫、武器训练、治安巡逻和风险预案', sort_order = 50, status = 'ACTIVE'
WHERE slug = 'security' OR id = 5;

UPDATE bbs_categories
SET name = '航海贸易', description = '港口、船只、航线、贸易和外部接触记录', sort_order = 60, status = 'ACTIVE'
WHERE slug = 'navigation' OR id = 6;
