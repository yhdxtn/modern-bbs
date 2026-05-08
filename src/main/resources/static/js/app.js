document.querySelectorAll('textarea:not([data-no-autoresize])').forEach((textarea) => {
    const resize = () => {
        textarea.style.height = 'auto';
        textarea.style.height = `${textarea.scrollHeight}px`;
    };
    textarea.addEventListener('input', resize);
    resize();
});

(function initNewWorldDashboard() {
    const clockEl = document.getElementById('new-world-clock');
    const dateEl = document.getElementById('new-world-date');
    const labelEl = document.getElementById('new-world-time-label');
    const worldMapEl = document.getElementById('world-map');
    const chinaMapEl = document.getElementById('china-map');
    const hainanMapEl = document.getElementById('hainan-map');

    if (!clockEl || !dateEl) {
        return;
    }

    const dashboard = window.COUNCIL_DASHBOARD || {};
    const timeLabel = dashboard.label || '新世界标准时 NST';
    if (labelEl) labelEl.textContent = timeLabel;

    const weekLabels = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
    const baseDateTime = typeof dashboard.baseDateTime === 'string' && dashboard.baseDateTime.trim()
        ? dashboard.baseDateTime.trim()
        : '1638-05-06T08:00:00';
    const syncEpochMillis = Number.isFinite(Number(dashboard.syncEpochMillis))
        ? Number(dashboard.syncEpochMillis)
        : Date.now();
    const baseMillis = parseHistoricalDate(baseDateTime).getTime();

    function parseHistoricalDate(value) {
        const normalized = String(value || '1638-05-06T08:00:00').replace(' ', 'T');
        const match = normalized.match(/^(\d{1,4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})(?::(\d{2}))?/);
        if (!match) {
            return new Date(1638, 4, 6, 8, 0, 0);
        }
        return new Date(
            Number(match[1]),
            Number(match[2]) - 1,
            Number(match[3]),
            Number(match[4]),
            Number(match[5]),
            Number(match[6] || 0)
        );
    }

    function formatNewWorldTime() {
        const elapsed = Date.now() - syncEpochMillis;
        const target = new Date(baseMillis + elapsed);
        const yyyy = String(target.getFullYear()).padStart(4, '0');
        const mm = String(target.getMonth() + 1).padStart(2, '0');
        const dd = String(target.getDate()).padStart(2, '0');
        const hh = String(target.getHours()).padStart(2, '0');
        const mi = String(target.getMinutes()).padStart(2, '0');
        const ss = String(target.getSeconds()).padStart(2, '0');
        clockEl.textContent = `${hh}:${mi}:${ss}`;
        dateEl.textContent = `${yyyy}年${mm}月${dd}日 ${weekLabels[target.getDay()]}`;
    }

    formatNewWorldTime();
    setInterval(formatNewWorldTime, 1000);

    const distribution = {
        world: Array.isArray(dashboard.world) ? dashboard.world : [],
        china: Array.isArray(dashboard.china) ? dashboard.china : [],
        strategic: Array.isArray(dashboard.strategic) ? dashboard.strategic : []
    };

    const toNumber = (value) => Number(value) || 0;
    const sumValues = (list) => list.reduce((sum, item) => sum + toNumber(item.value), 0);
    const sortDesc = (list) => [...list].sort((a, b) => toNumber(b.value) - toNumber(a.value));
    const topChina = sortDesc(distribution.china)[0] || { name: '--', value: 0 };
    const topStrategic = sortDesc(distribution.strategic)[0] || topChina;

    const setText = (id, text) => {
        const el = document.getElementById(id);
        if (el) el.textContent = text;
    };

    setText('global-elders-total', sumValues(distribution.world).toLocaleString('zh-CN'));
    setText('china-elders-total', sumValues(distribution.china).toLocaleString('zh-CN'));
    setText('global-station-count', distribution.world.length.toLocaleString('zh-CN'));
    setText('top-province-name', topStrategic.name);
    setText('top-province-count', `${toNumber(topStrategic.value)} 名元老`);

    const worldPositions = {
        'China': [75, 48], 'Taiwan': [78, 55], 'Japan': [84, 45], 'South Korea': [80, 43],
        'Vietnam': [71, 63], 'Singapore': [73, 68], 'Malaysia': [72, 66], 'Thailand': [71, 61],
        'Philippines': [79, 64], 'Indonesia': [76, 74], 'Cambodia': [72, 63], 'Laos': [71, 59],
        'Myanmar': [68, 59], 'India': [66, 58]
    };

    const chinaPositions = {
        '北京': [61, 29], '天津': [64, 31], '河北': [60, 34], '山西': [55, 36],
        '内蒙古': [48, 25], '辽宁': [69, 27], '吉林': [73, 22], '黑龙江': [74, 14],
        '上海': [70, 52], '江苏': [67, 50], '浙江': [68, 58], '安徽': [62, 52],
        '福建': [65, 65], '江西': [59, 62], '山东': [65, 42], '河南': [57, 47],
        '湖北': [55, 55], '湖南': [54, 63], '广东': [58, 73], '广西': [48, 74],
        '海南': [53, 88], '重庆': [45, 58], '四川': [38, 58], '贵州': [45, 68],
        '云南': [35, 74], '西藏': [22, 57], '陕西': [50, 47], '甘肃': [39, 42],
        '青海': [31, 45], '宁夏': [46, 38], '新疆': [17, 29], '台湾': [72, 73],
        '香港': [60, 78], '澳门': [58, 79]
    };

    const strategicPositions = {
        '临高首都区 / 登陆点': [48, 60], '临高': [48, 60], '登陆点': [48, 60],
        '百仞城政务区': [51, 56], '百仞城': [51, 56],
        '博铺港': [43, 58],
        '海南主基地': [49, 63], '海南': [49, 63],
        '广东工业转运区': [39, 40], '广东': [39, 40],
        '台湾观察与技术联络点': [72, 47], '台湾': [72, 47],
        '济州岛远洋联络点': [69, 16], '济州岛': [69, 16],
        '越南联络点': [39, 82], '越南': [39, 82],
        '日本观察点': [78, 20], '日本': [78, 20],
        '琼州海峡航运点': [45, 52], '琼州海峡': [45, 52],
        '西沙前哨': [50, 78], '西沙': [50, 78],
        '南沙补给线': [64, 88], '南沙': [64, 88],
        '香港': [43, 44], '澳门': [41, 45], '福建': [63, 37]
    };

    renderDistributionMap(worldMapEl, distribution.world, {
        title: '亚洲驻点热力',
        type: 'world',
        positions: worldPositions,
        unit: '名',
        highlightNames: ['China', 'Vietnam', 'Japan', 'Taiwan', 'South Korea'],
        fallbackHint: '元老分布已改为亚洲范围；越南、日本、济州岛等点位可在后台编辑。'
    });

    renderDistributionMap(chinaMapEl, distribution.china, {
        title: '全国省份热力',
        type: 'china',
        positions: chinaPositions,
        unit: '名',
        highlightNames: ['海南', '广东', '台湾', '香港', '澳门'],
        fallbackHint: '海南为主基地，广东、台湾等重点区域会根据元老数量加深颜色。'
    });

    renderDistributionMap(hainanMapEl, distribution.strategic, {
        title: '临高首都区海图',
        type: 'strategic',
        positions: strategicPositions,
        unit: '名',
        highlightNames: ['临高首都区 / 登陆点', '临高', '登陆点', '百仞城政务区', '博铺港', '海南主基地', '海南', '广东工业转运区', '广东', '台湾观察与技术联络点', '台湾', '济州岛远洋联络点', '济州岛', '越南联络点', '日本观察点'],
        fallbackHint: '该图专门表现临高登陆点与首都区，并联动海南、南海、广东、台湾、济州岛、越南、日本等战略节点。'
    });

    function renderDistributionMap(container, data, options) {
        if (!container) return;
        const list = sortDesc(data || []);
        const max = Math.max(1, ...list.map((item) => toNumber(item.value)));
        const placed = [];
        const unplaced = [];
        const positions = options.positions || {};

        list.forEach((item) => {
            const name = item.name || '';
            const pos = positions[name];
            if (pos) placed.push({ ...item, pos });
            else unplaced.push(item);
        });

        const boardClass = options.type === 'strategic' ? 'geo-board sea-board' : `geo-board ${options.type}-board`;
        const nodes = placed.map((item) => mapNodeHtml(item, max, options)).join('');
        const ranking = list.slice(0, 10).map((item, index) => rankRowHtml(item, max, index, options)).join('');
        const extra = unplaced.slice(0, 8).map((item) => `<span>${escapeHtml(item.name)} ${toNumber(item.value)}${options.unit}</span>`).join('');
        const routes = options.type === 'strategic' ? strategicRoutesSvg() : '';

        container.innerHTML = `
            <div class="offline-map ${options.type}-offline-map">
                <div class="${boardClass}">
                    ${routes}
                    <div class="map-watermark">${escapeHtml(options.title)}</div>
                    ${nodes || '<div class="map-empty-hint">暂无可显示驻点，请到后台添加数据。</div>'}
                </div>
                <div class="map-side-panel">
                    <div class="map-scale"><span></span><span></span><span></span><span></span><em>少 → 多</em></div>
                    <div class="rank-list">${ranking || '<p class="muted">暂无排行数据</p>'}</div>
                    ${extra ? `<div class="unplaced-list"><strong>其他驻点</strong>${extra}</div>` : ''}
                    <p class="map-hint">${escapeHtml(options.fallbackHint || '')}</p>
                </div>
            </div>
        `;
    }

    function mapNodeHtml(item, max, options) {
        const value = toNumber(item.value);
        const ratio = max <= 0 ? 0 : value / max;
        const level = Math.max(1, Math.ceil(ratio * 5));
        const size = 14 + Math.round(ratio * 34);
        const isHighlight = (options.highlightNames || []).includes(item.name);
        const [left, top] = item.pos;
        const className = `map-node level-${level}${isHighlight ? ' key-node' : ''}`;
        return `
            <button class="${className}" style="left:${left}%;top:${top}%;--node-size:${size}px" title="${escapeHtml(item.name)}：${value}${options.unit}">
                <span class="node-dot"></span>
                <span class="node-label"><b>${escapeHtml(item.name)}</b><em>${value}${options.unit}</em></span>
            </button>
        `;
    }

    function rankRowHtml(item, max, index, options) {
        const value = toNumber(item.value);
        const width = Math.max(4, Math.round(value / Math.max(1, max) * 100));
        return `
            <div class="rank-row">
                <i>${index + 1}</i>
                <span>${escapeHtml(item.name)}</span>
                <strong>${value}${options.unit}</strong>
                <div class="rank-bar"><b style="width:${width}%"></b></div>
            </div>
        `;
    }

    function strategicRoutesSvg() {
        return `
            <svg class="route-layer" viewBox="0 0 100 100" preserveAspectRatio="none" aria-hidden="true">
                <path d="M48 60 C46 58, 44 58, 43 58" />
                <path d="M48 60 C49 58, 50 57, 51 56" />
                <path d="M48 60 C44 52, 41 45, 39 40" />
                <path d="M48 60 C57 55, 64 49, 72 47" />
                <path d="M48 60 C58 42, 64 25, 69 16" />
                <path d="M48 60 C42 72, 40 78, 39 82" />
                <path d="M48 60 C49 68, 50 73, 50 78" />
                <path d="M48 60 C55 72, 60 80, 64 88" />
            </svg>
        `;
    }

    function escapeHtml(value) {
        return String(value ?? '')
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;')
            .replaceAll('"', '&quot;')
            .replaceAll("'", '&#039;');
    }
})();

(function initDepartmentCarousel() {
    document.querySelectorAll('[data-department-carousel]').forEach((carousel) => {
        const slides = Array.from(carousel.querySelectorAll('.carousel-slide'));
        const dots = Array.from(carousel.querySelectorAll('[data-carousel-dot]'));
        const prev = carousel.querySelector('[data-carousel-prev]');
        const next = carousel.querySelector('[data-carousel-next]');
        if (slides.length <= 1) return;

        let index = 0;
        let timer = null;

        const show = (target) => {
            index = (target + slides.length) % slides.length;
            slides.forEach((slide, i) => slide.classList.toggle('active', i === index));
            dots.forEach((dot, i) => dot.classList.toggle('active', i === index));
        };
        const start = () => {
            stop();
            timer = window.setInterval(() => show(index + 1), 5200);
        };
        const stop = () => {
            if (timer) window.clearInterval(timer);
            timer = null;
        };

        prev?.addEventListener('click', () => { show(index - 1); start(); });
        next?.addEventListener('click', () => { show(index + 1); start(); });
        dots.forEach((dot) => {
            dot.addEventListener('click', () => {
                show(Number(dot.dataset.carouselDot || 0));
                start();
            });
        });
        carousel.addEventListener('mouseenter', stop);
        carousel.addEventListener('mouseleave', start);
        start();
    });
})();

(function initNestedReplies() {
    const closeOtherReplyForms = (currentForm) => {
        document.querySelectorAll('.bili-inline-reply-form, .inline-reply-form').forEach((item) => {
            if (item !== currentForm) item.hidden = true;
        });
    };

    document.querySelectorAll('[data-reply-root]').forEach((button) => {
        button.addEventListener('click', () => {
            const rootId = button.getAttribute('data-reply-root');
            const parentId = button.getAttribute('data-reply-parent') || rootId;
            const target = button.getAttribute('data-reply-target') || '该元老';
            const form = document.getElementById(`reply-form-${rootId}`);
            if (!form) return;
            closeOtherReplyForms(form);

            const input = form.querySelector('input[name="parentId"]');
            const textarea = form.querySelector('textarea[name="content"]');
            if (input) input.value = parentId;
            if (textarea) {
                textarea.placeholder = `回复 ${target}...`;
            }
            form.hidden = false;
            form.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
            window.setTimeout(() => textarea?.focus(), 80);
        });
    });

    // 兼容旧模板里的回复按钮
    document.querySelectorAll('[data-reply-toggle]').forEach((button) => {
        button.addEventListener('click', () => {
            const id = button.getAttribute('data-reply-toggle');
            const form = document.getElementById(`reply-form-${id}`);
            if (!form) return;
            closeOtherReplyForms(form);
            form.hidden = !form.hidden;
            if (!form.hidden) {
                const textarea = form.querySelector('textarea');
                textarea?.focus();
            }
        });
    });

    document.querySelectorAll('[data-reply-cancel]').forEach((button) => {
        button.addEventListener('click', () => {
            const id = button.getAttribute('data-reply-cancel');
            const form = document.getElementById(`reply-form-${id}`);
            if (form) form.hidden = true;
        });
    });
})();

(function enhanceBiliReplyDetails() {
    document.querySelectorAll('.bili-reply-box').forEach((box) => {
        box.addEventListener('toggle', () => {
            if (!box.open) return;
            const thread = box.closest('.comment-thread');
            if (thread) {
                thread.querySelectorAll('.bili-reply-box').forEach((other) => {
                    if (other !== box) other.open = false;
                });
            }
            const textarea = box.querySelector('textarea');
            window.setTimeout(() => textarea?.focus(), 80);
        });
    });

    document.querySelectorAll('[data-close-reply]').forEach((button) => {
        button.addEventListener('click', () => {
            const box = button.closest('.bili-reply-box');
            if (box) box.open = false;
        });
    });
})();

(function initRichPostEditor() {
    const editor = document.querySelector('[data-rich-editor]');
    if (!editor) return;

    const form = document.getElementById('post-compose-form');
    const title = form?.querySelector('input[name="title"]');
    const counter = document.querySelector('[data-title-counter]');
    const preview = document.querySelector('[data-editor-preview]');
    const split = document.querySelector('[data-editor-split]');
    const fileInput = document.getElementById('post-images-input');
    const mdImportInput = document.getElementById('md-import-input');
    const uploadName = document.querySelector('[data-upload-name]');
    const draftKey = 'qiming-bbs-compose-draft-v2';

    function selectedText(fallback) {
        const start = editor.selectionStart || 0;
        const end = editor.selectionEnd || 0;
        return editor.value.slice(start, end) || fallback || '';
    }

    function replaceSelection(text, cursorOffset) {
        const start = editor.selectionStart || 0;
        const end = editor.selectionEnd || 0;
        const before = editor.value.slice(0, start);
        const after = editor.value.slice(end);
        editor.value = before + text + after;
        const target = start + (typeof cursorOffset === 'number' ? cursorOffset : text.length);
        editor.focus();
        editor.setSelectionRange(target, target);
        editor.dispatchEvent(new Event('input'));
    }

    function wrap(prefix, suffix, placeholder) {
        const text = selectedText(placeholder);
        const result = prefix + text + suffix;
        replaceSelection(result, prefix.length + text.length);
    }

    function insertLine(prefix, placeholder) {
        const text = selectedText(placeholder).split('\n').map((line) => prefix + (line || placeholder)).join('\n');
        replaceSelection(text);
    }

    function insertTable() {
        replaceSelection('\n| 项目 | 说明 |\n| --- | --- |\n| 背景 |  |\n| 需求 |  |\n| 风险 |  |\n');
    }

    function insertTemplate(type) {
        const templates = {
            outline: '\n## 背景\n\n## 当前资源\n\n## 执行方案\n\n## 风险与争议\n\n## 需要元老院协调事项\n',
            risk: '\n## 风险清单\n\n- [ ] 人员风险：\n- [ ] 物资风险：\n- [ ] 通信风险：\n- [ ] 外部势力风险：\n\n## 应对预案\n',
            military: '\n## 军务情况\n\n## 敌情 / 民情\n\n## 我方兵力与物资\n\n## 需要批准的行动\n'
        };
        replaceSelection(templates[type] || templates.outline);
    }

    function escapeHtml(value) {
        return String(value || '')
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;')
            .replaceAll('"', '&quot;')
            .replaceAll("'", '&#039;');
    }

    function inlineMarkdown(line) {
        let html = escapeHtml(line);
        html = html.replace(/!\[([^\]]{0,80})]\((\/uploads\/[^)\s]+)\)/g, '<figure class="post-image"><img src="$2" alt="$1"><figcaption>$1</figcaption></figure>');
        html = html.replace(/`([^`]+)`/g, '<code>$1</code>');
        html = html.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
        html = html.replace(/~~([^~]+)~~/g, '<del>$1</del>');
        html = html.replace(/\*([^*]+)\*/g, '<em>$1</em>');
        html = html.replace(/\[([^\]]+)]\((https?:\/\/[^)\s]+)\)/g, '<a href="$2" target="_blank" rel="noopener">$1</a>');
        return html;
    }

    function renderMarkdown(src) {
        const lines = String(src || '').replace(/\r\n/g, '\n').split('\n');
        let html = '';
        let inCode = false;
        let code = [];
        let listType = null;
        const closeList = () => {
            if (listType) { html += `</${listType}>`; listType = null; }
        };
        const openList = (type) => {
            if (listType !== type) { closeList(); html += `<${type}>`; listType = type; }
        };
        for (const raw of lines) {
            if (raw.trim().startsWith('```')) {
                if (!inCode) { closeList(); inCode = true; code = []; }
                else { html += '<pre><code>' + escapeHtml(code.join('\n')) + '</code></pre>'; inCode = false; }
                continue;
            }
            if (inCode) { code.push(raw); continue; }
            const line = raw.trimEnd();
            if (!line.trim()) { closeList(); html += '<br>'; continue; }
            if (/^###\s+/.test(line)) { closeList(); html += '<h3>' + inlineMarkdown(line.replace(/^###\s+/, '')) + '</h3>'; continue; }
            if (/^##\s+/.test(line)) { closeList(); html += '<h2>' + inlineMarkdown(line.replace(/^##\s+/, '')) + '</h2>'; continue; }
            if (/^#\s+/.test(line)) { closeList(); html += '<h1>' + inlineMarkdown(line.replace(/^#\s+/, '')) + '</h1>'; continue; }
            if (/^>\s+/.test(line)) { closeList(); html += '<blockquote>' + inlineMarkdown(line.replace(/^>\s+/, '')) + '</blockquote>'; continue; }
            if (/^[-*]\s+/.test(line)) { openList('ul'); html += '<li>' + inlineMarkdown(line.replace(/^[-*]\s+/, '')) + '</li>'; continue; }
            if (/^\d+\.\s+/.test(line)) { openList('ol'); html += '<li>' + inlineMarkdown(line.replace(/^\d+\.\s+/, '')) + '</li>'; continue; }
            if (/^\|.*\|$/.test(line)) { closeList(); html += '<p class="table-preview-line">' + inlineMarkdown(line) + '</p>'; continue; }
            closeList();
            html += '<p>' + inlineMarkdown(line) + '</p>';
        }
        closeList();
        if (inCode) html += '<pre><code>' + escapeHtml(code.join('\n')) + '</code></pre>';
        return html || '<p class="muted">正文预览会显示在这里。</p>';
    }

    function updatePreview() {
        if (preview) preview.innerHTML = renderMarkdown(editor.value);
    }

    function updateCounter() {
        if (!title || !counter) return;
        const len = title.value.trim().length;
        const lack = Math.max(0, 5 - len);
        counter.textContent = lack > 0 ? `还需要输入 ${lack} 个字` : `${len}/120`;
        counter.classList.toggle('ok', lack === 0);
    }

    document.querySelectorAll('[data-md]').forEach((button) => {
        button.addEventListener('click', () => {
            const action = button.dataset.md;
            if (action === 'bold') wrap('**', '**', '加粗文字');
            if (action === 'italic') wrap('*', '*', '斜体文字');
            if (action === 'heading') insertLine('## ', '小标题');
            if (action === 'strike') wrap('~~', '~~', '删除线文字');
            if (action === 'ul') insertLine('- ', '列表项');
            if (action === 'ol') insertLine('1. ', '列表项');
            if (action === 'task') insertLine('- [ ] ', '待办事项');
            if (action === 'quote') insertLine('> ', '引用内容');
            if (action === 'inlineCode') wrap('`', '`', 'code');
            if (action === 'codeBlock') replaceSelection('\n```\n' + selectedText('代码内容') + '\n```\n');
            if (action === 'table') insertTable();
            if (action === 'link') wrap('[', '](https://)', '链接文字');
            if (action === 'image') fileInput?.click();
            if (action === 'divider') replaceSelection('\n---\n');
        });
    });

    document.querySelector('[data-choose-images]')?.addEventListener('click', () => fileInput?.click());
    document.querySelector('[data-import-md]')?.addEventListener('click', () => mdImportInput?.click());
    mdImportInput?.addEventListener('change', () => {
        const file = mdImportInput.files && mdImportInput.files[0];
        if (!file) return;
        if (file.size > 1024 * 1024) {
            alert('MD 文件不能超过 1MB。');
            mdImportInput.value = '';
            return;
        }
        const reader = new FileReader();
        reader.onload = () => {
            const text = String(reader.result || '');
            if (editor.value.trim() && !confirm('导入会覆盖当前编辑区内容，是否继续？')) {
                mdImportInput.value = '';
                return;
            }
            editor.value = text;
            editor.dispatchEvent(new Event('input'));
            if (uploadName) uploadName.textContent = `已导入 ${file.name}，左侧为 Markdown 原文，右侧为实时预览。`;
            mdImportInput.value = '';
        };
        reader.onerror = () => alert('MD 文件读取失败，请重新选择。');
        reader.readAsText(file, 'UTF-8');
    });
    fileInput?.addEventListener('change', () => {
        const names = Array.from(fileInput.files || []).map((file) => file.name);
        if (uploadName) uploadName.textContent = names.length ? `正在准备 ${names.length} 张图片：${names.slice(0, 3).join('、')}${names.length > 3 ? '...' : ''}` : '支持 jpg、png、gif、webp；图片会插入光标位置。';
    });

    document.querySelector('[data-toggle-preview]')?.addEventListener('click', () => {
        split?.classList.toggle('preview-hidden');
    });

    document.querySelectorAll('[data-template]').forEach((button) => {
        button.addEventListener('click', () => insertTemplate(button.dataset.template));
    });

    document.querySelector('[data-save-draft]')?.addEventListener('click', () => {
        const payload = {
            title: title?.value || '',
            content: editor.value,
            categoryId: form?.querySelector('select[name="categoryId"]')?.value || '',
            savedAt: Date.now()
        };
        localStorage.setItem(draftKey, JSON.stringify(payload));
        alert('草稿已保存在当前浏览器。');
    });

    try {
        const draft = JSON.parse(localStorage.getItem(draftKey) || 'null');
        if (draft && !editor.value.trim() && !title?.value.trim()) {
            if (confirm('检测到本地草稿，是否恢复？')) {
                if (title) title.value = draft.title || '';
                editor.value = draft.content || '';
                const select = form?.querySelector('select[name="categoryId"]');
                if (select && draft.categoryId) select.value = draft.categoryId;
            }
        }
    } catch (ignored) {}

    editor.addEventListener('input', updatePreview);
    title?.addEventListener('input', updateCounter);
    updatePreview();
    updateCounter();
})();

(function initBiliFeedRepliesV2() {
    const closeOtherReplyPanels = (current) => {
        document.querySelectorAll('.lg-inline-reply-panel, .bili-inline-reply-panel, .bili-inline-reply-form, .inline-reply-form').forEach((form) => {
            if (form !== current) form.hidden = true;
        });
    };

    document.querySelectorAll('.bili-feed-comments [data-reply-root], .lg-comment-area [data-reply-root]').forEach((button) => {
        button.addEventListener('click', () => {
            const rootId = button.getAttribute('data-reply-root');
            const parentId = button.getAttribute('data-reply-parent') || rootId;
            const target = button.getAttribute('data-reply-target') || '该元老';
            const form = document.getElementById(`reply-form-${rootId}`);
            if (!form) return;
            closeOtherReplyPanels(form);
            const input = form.querySelector('input[name="parentId"]');
            const textarea = form.querySelector('textarea[name="content"]');
            const strong = form.querySelector('.reply-panel-title strong');
            if (input) input.value = parentId;
            if (strong) strong.textContent = `@${target}`;
            if (textarea) textarea.placeholder = `回复 ${target}...`;
            form.hidden = false;
            form.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
            window.setTimeout(() => textarea?.focus(), 80);
        });
    });

    document.querySelectorAll('.bili-feed-comments [data-reply-cancel], .lg-comment-area [data-reply-cancel]').forEach((button) => {
        button.addEventListener('click', () => {
            const id = button.getAttribute('data-reply-cancel');
            const form = document.getElementById(`reply-form-${id}`);
            if (form) form.hidden = true;
        });
    });

    document.querySelectorAll('[data-show-replies]').forEach((button) => {
        button.addEventListener('click', () => {
            const rootId = button.getAttribute('data-show-replies');
            document.querySelectorAll(`[data-extra-of="${rootId}"]`).forEach((item) => item.classList.remove('is-extra-reply'));
            document.querySelectorAll(`[data-extra-of="${rootId}"]`).forEach((item) => item.classList.remove('lg-extra-reply'));
            button.hidden = true;
        });
    });
})();

(function initCompactCommentRepliesFinal() {
    const closeOther = (current) => {
        document.querySelectorAll('.compact-reply-panel').forEach((panel) => {
            if (panel !== current) panel.hidden = true;
        });
    };
    document.querySelectorAll('.compact-comment-area [data-reply-root]').forEach((button) => {
        button.addEventListener('click', () => {
            const rootId = button.getAttribute('data-reply-root');
            const parentId = button.getAttribute('data-reply-parent') || rootId;
            const target = button.getAttribute('data-reply-target') || '该元老';
            const panel = document.getElementById(`reply-form-${rootId}`);
            if (!panel) return;
            closeOther(panel);
            const input = panel.querySelector('input[name="parentId"]');
            const textarea = panel.querySelector('textarea[name="content"]');
            const strong = panel.querySelector('.reply-panel-title strong');
            if (input) input.value = parentId;
            if (strong) strong.textContent = `@${target}`;
            if (textarea) textarea.placeholder = `回复 ${target}...`;
            panel.hidden = false;
            panel.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
            window.setTimeout(() => textarea?.focus(), 80);
        });
    });
    document.querySelectorAll('.compact-comment-area [data-reply-cancel]').forEach((button) => {
        button.addEventListener('click', () => {
            const id = button.getAttribute('data-reply-cancel');
            const panel = document.getElementById(`reply-form-${id}`);
            if (panel) panel.hidden = true;
        });
    });
    document.querySelectorAll('.compact-comment-area [data-show-replies]').forEach((button) => {
        button.addEventListener('click', () => {
            const rootId = button.getAttribute('data-show-replies');
            document.querySelectorAll(`[data-extra-of="${rootId}"]`).forEach((item) => {
                item.classList.remove('is-extra-compact-reply', 'is-extra-reply', 'lg-extra-reply');
            });
            button.hidden = true;
        });
    });
})();

(function initInlineImageUploadToCursor() {
    const inputs = document.querySelectorAll('[data-inline-image-input]');
    if (!inputs.length) return;

    function statusElement(input) {
        const selector = input.getAttribute('data-upload-status');
        if (!selector) return null;
        try { return document.querySelector(selector); } catch (ignored) { return null; }
    }

    function setStatus(input, text) {
        const el = statusElement(input);
        if (el) el.textContent = text;
    }

    function insertAtCursor(textarea, text) {
        if (!textarea) return;
        const start = textarea.selectionStart ?? textarea.value.length;
        const end = textarea.selectionEnd ?? textarea.value.length;
        const before = textarea.value.slice(0, start);
        const after = textarea.value.slice(end);
        const needsBefore = before && !before.endsWith('\n') ? '\n\n' : '';
        const needsAfter = after && !after.startsWith('\n') ? '\n\n' : '\n';
        const insertion = needsBefore + text + needsAfter;
        textarea.value = before + insertion + after;
        const pos = before.length + insertion.length;
        textarea.focus();
        textarea.setSelectionRange(pos, pos);
        textarea.dispatchEvent(new Event('input', { bubbles: true }));
    }

    async function uploadOne(file) {
        const formData = new FormData();
        formData.append('image', file);
        const response = await fetch('/posts/images', {
            method: 'POST',
            body: formData,
            credentials: 'same-origin'
        });
        if (!response.ok) {
            const text = await response.text().catch(() => '');
            throw new Error(text || `上传失败：HTTP ${response.status}`);
        }
        return response.json();
    }

    inputs.forEach((input) => {
        input.addEventListener('change', async () => {
            const files = Array.from(input.files || []);
            if (!files.length) return;
            const targetSelector = input.getAttribute('data-target-textarea');
            const textarea = targetSelector ? document.querySelector(targetSelector) : input.closest('form')?.querySelector('textarea[name="content"]');
            if (!textarea) {
                setStatus(input, '没有找到要插入图片的编辑框。');
                input.value = '';
                return;
            }
            setStatus(input, `正在压缩并上传 ${files.length} 张图片...`);
            input.disabled = true;
            try {
                let count = 0;
                for (const file of files) {
                    const result = await uploadOne(file);
                    insertAtCursor(textarea, result.markdown || `![图片](${result.url})`);
                    count += 1;
                }
                setStatus(input, `已插入 ${count} 张图片，可继续在图片前后写文字。`);
            } catch (error) {
                console.error(error);
                setStatus(input, '图片上传失败，请检查图片大小或重新登录。');
                alert(error.message || '图片上传失败');
            } finally {
                input.disabled = false;
                input.value = '';
            }
        });
    });
})();

(function initNavMoreDropdownFix() {
    document.querySelectorAll('.nav-more').forEach((box) => {
        const summary = box.querySelector('summary');
        const menu = box.querySelector('.nav-more-menu');
        if (!summary || !menu) return;

        summary.setAttribute('role', 'button');
        summary.setAttribute('aria-haspopup', 'menu');
        summary.setAttribute('aria-expanded', box.hasAttribute('open') ? 'true' : 'false');
        menu.setAttribute('role', 'menu');

        const sync = () => {
            const open = box.hasAttribute('open');
            box.classList.toggle('is-open', open);
            summary.setAttribute('aria-expanded', open ? 'true' : 'false');
        };

        box.addEventListener('toggle', sync);
        sync();
    });

    document.addEventListener('click', (event) => {
        document.querySelectorAll('.nav-more[open]').forEach((box) => {
            if (!box.contains(event.target)) {
                box.removeAttribute('open');
                box.classList.remove('is-open');
                const summary = box.querySelector('summary');
                if (summary) summary.setAttribute('aria-expanded', 'false');
            }
        });
    });

    document.addEventListener('keydown', (event) => {
        if (event.key !== 'Escape') return;
        document.querySelectorAll('.nav-more[open]').forEach((box) => {
            box.removeAttribute('open');
            box.classList.remove('is-open');
            const summary = box.querySelector('summary');
            if (summary) {
                summary.setAttribute('aria-expanded', 'false');
                summary.focus();
            }
        });
    });
})();

(function initCommentMoreMenuClose() {
    document.addEventListener('click', (event) => {
        document.querySelectorAll('.comment-more-menu[open]').forEach((menu) => {
            if (!menu.contains(event.target)) {
                menu.removeAttribute('open');
            }
        });
    });
    document.addEventListener('keydown', (event) => {
        if (event.key !== 'Escape') return;
        document.querySelectorAll('.comment-more-menu[open]').forEach((menu) => menu.removeAttribute('open'));
    });
})();
