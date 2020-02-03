<!DOCTYPE html>
<html lang="en">
<head>
    <title>API</title>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.5/css/bulma.min.css" integrity="sha256-vK3UTo/8wHbaUn+dTQD0X6dzidqc5l7gczvH+Bnowwk=" crossorigin="anonymous" id="bulma-theme-light" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulmaswatch@0.7.5/cyborg/bulmaswatch.min.css" integrity="sha256-NEPZJFJGDcH6K+NW0Ij8VtItmbltoDzXHaZ4oBQzuvU=" crossorigin="anonymous" media="none" id="bulma-theme-dark" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.9.0/css/fontawesome.min.css" integrity="sha256-AaQqnjfGDRZd/lUp0Dvy7URGOyRsh8g9JdWUkyYxNfI=" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.9.0/css/solid.min.css" integrity="sha256-3FfMfpeajSEpxWZTFowWZPTv7k3GEu7w4rQv49EWsEY=" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/prism-themes@1.1.0/themes/prism-a11y-dark.css" integrity="sha256-d2qy226pP+oHAtEQPujaiXPslYW1Rmtla3Ivu1fFYxU=" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma-switch@2.0.0/dist/css/bulma-switch.min.css" integrity="sha256-jCV/cXwP13w0GNHLgFx6SFgTNAvJPvS5MIhuE30Ng08=" crossorigin="anonymous">

    <style>
        @media screen and (min-width: 768px) {
            .navbar-burger {
                display: none;
            }
        }
    </style>
</head>
<body class="has-navbar-fixed-top">
<script>var main = (function () {
        'use strict';

        function noop() { }
        const identity = x => x;
        function assign(tar, src) {
            // @ts-ignore
            for (const k in src)
                tar[k] = src[k];
            return tar;
        }
        function is_promise(value) {
            return value && typeof value === 'object' && typeof value.then === 'function';
        }
        function add_location(element, file, line, column, char) {
            element.__svelte_meta = {
                loc: { file, line, column, char }
            };
        }
        function run(fn) {
            return fn();
        }
        function blank_object() {
            return Object.create(null);
        }
        function run_all(fns) {
            fns.forEach(run);
        }
        function is_function(thing) {
            return typeof thing === 'function';
        }
        function safe_not_equal(a, b) {
            return a != a ? b == b : a !== b || ((a && typeof a === 'object') || typeof a === 'function');
        }
        function not_equal(a, b) {
            return a != a ? b == b : a !== b;
        }
        function validate_store(store, name) {
            if (!store || typeof store.subscribe !== 'function') {
                throw new Error(`'${name}' is not a store with a 'subscribe' method`);
            }
        }
        function subscribe(store, callback) {
            const unsub = store.subscribe(callback);
            return unsub.unsubscribe ? () => unsub.unsubscribe() : unsub;
        }
        function get_store_value(store) {
            let value;
            subscribe(store, _ => value = _)();
            return value;
        }
        function component_subscribe(component, store, callback) {
            component.$$.on_destroy.push(subscribe(store, callback));
        }
        function create_slot(definition, ctx, $$scope, fn) {
            if (definition) {
                const slot_ctx = get_slot_context(definition, ctx, $$scope, fn);
                return definition[0](slot_ctx);
            }
        }
        function get_slot_context(definition, ctx, $$scope, fn) {
            return definition[1] && fn
                ? assign($$scope.ctx.slice(), definition[1](fn(ctx)))
                : $$scope.ctx;
        }
        function get_slot_changes(definition, $$scope, dirty, fn) {
            if (definition[2] && fn) {
                const lets = definition[2](fn(dirty));
                if (typeof $$scope.dirty === 'object') {
                    const merged = [];
                    const len = Math.max($$scope.dirty.length, lets.length);
                    for (let i = 0; i < len; i += 1) {
                        merged[i] = $$scope.dirty[i] | lets[i];
                    }
                    return merged;
                }
                return $$scope.dirty | lets;
            }
            return $$scope.dirty;
        }
        function exclude_internal_props(props) {
            const result = {};
            for (const k in props)
                if (k[0] !== '$')
                    result[k] = props[k];
            return result;
        }
        function once(fn) {
            let ran = false;
            return function (...args) {
                if (ran)
                    return;
                ran = true;
                fn.call(this, ...args);
            };
        }
        function null_to_empty(value) {
            return value == null ? '' : value;
        }
        function set_store_value(store, ret, value = ret) {
            store.set(value);
            return ret;
        }
        const has_prop = (obj, prop) => Object.prototype.hasOwnProperty.call(obj, prop);

        const is_client = typeof window !== 'undefined';
        let now = is_client
            ? () => window.performance.now()
            : () => Date.now();
        let raf = is_client ? cb => requestAnimationFrame(cb) : noop;
        // used internally for testing
        function set_now(fn) {
            now = fn;
        }
        function set_raf(fn) {
            raf = fn;
        }

        const tasks = new Set();
        function run_tasks(now) {
            tasks.forEach(task => {
                if (!task.c(now)) {
                    tasks.delete(task);
                    task.f();
                }
            });
            if (tasks.size !== 0)
                raf(run_tasks);
        }
        /**
         * For testing purposes only!
         */
        function clear_loops() {
            tasks.clear();
        }
        /**
         * Creates a new task that runs on each raf frame
         * until it returns a falsy value or is aborted
         */
        function loop(callback) {
            let task;
            if (tasks.size === 0)
                raf(run_tasks);
            return {
                promise: new Promise(fulfill => {
                    tasks.add(task = { c: callback, f: fulfill });
                }),
                abort() {
                    tasks.delete(task);
                }
            };
        }

        function append(target, node) {
            target.appendChild(node);
        }
        function insert(target, node, anchor) {
            target.insertBefore(node, anchor || null);
        }
        function detach(node) {
            node.parentNode.removeChild(node);
        }
        function destroy_each(iterations, detaching) {
            for (let i = 0; i < iterations.length; i += 1) {
                if (iterations[i])
                    iterations[i].d(detaching);
            }
        }
        function element(name) {
            return document.createElement(name);
        }
        function element_is(name, is) {
            return document.createElement(name, { is });
        }
        function object_without_properties(obj, exclude) {
            const target = {};
            for (const k in obj) {
                if (has_prop(obj, k)
                    // @ts-ignore
                    && exclude.indexOf(k) === -1) {
                    // @ts-ignore
                    target[k] = obj[k];
                }
            }
            return target;
        }
        function svg_element(name) {
            return document.createElementNS('http://www.w3.org/2000/svg', name);
        }
        function text(data) {
            return document.createTextNode(data);
        }
        function space() {
            return text(' ');
        }
        function empty() {
            return text('');
        }
        function listen(node, event, handler, options) {
            node.addEventListener(event, handler, options);
            return () => node.removeEventListener(event, handler, options);
        }
        function prevent_default(fn) {
            return function (event) {
                event.preventDefault();
                // @ts-ignore
                return fn.call(this, event);
            };
        }
        function stop_propagation(fn) {
            return function (event) {
                event.stopPropagation();
                // @ts-ignore
                return fn.call(this, event);
            };
        }
        function self$1(fn) {
            return function (event) {
                // @ts-ignore
                if (event.target === this)
                    fn.call(this, event);
            };
        }
        function attr(node, attribute, value) {
            if (value == null)
                node.removeAttribute(attribute);
            else if (node.getAttribute(attribute) !== value)
                node.setAttribute(attribute, value);
        }
        function set_attributes(node, attributes) {
            // @ts-ignore
            const descriptors = Object.getOwnPropertyDescriptors(node.__proto__);
            for (const key in attributes) {
                if (attributes[key] == null) {
                    node.removeAttribute(key);
                }
                else if (key === 'style') {
                    node.style.cssText = attributes[key];
                }
                else if (descriptors[key] && descriptors[key].set) {
                    node[key] = attributes[key];
                }
                else {
                    attr(node, key, attributes[key]);
                }
            }
        }
        function set_svg_attributes(node, attributes) {
            for (const key in attributes) {
                attr(node, key, attributes[key]);
            }
        }
        function set_custom_element_data(node, prop, value) {
            if (prop in node) {
                node[prop] = value;
            }
            else {
                attr(node, prop, value);
            }
        }
        function xlink_attr(node, attribute, value) {
            node.setAttributeNS('http://www.w3.org/1999/xlink', attribute, value);
        }
        function get_binding_group_value(group) {
            const value = [];
            for (let i = 0; i < group.length; i += 1) {
                if (group[i].checked)
                    value.push(group[i].__value);
            }
            return value;
        }
        function to_number(value) {
            return value === '' ? undefined : +value;
        }
        function time_ranges_to_array(ranges) {
            const array = [];
            for (let i = 0; i < ranges.length; i += 1) {
                array.push({ start: ranges.start(i), end: ranges.end(i) });
            }
            return array;
        }
        function children(element) {
            return Array.from(element.childNodes);
        }
        function claim_element(nodes, name, attributes, svg) {
            for (let i = 0; i < nodes.length; i += 1) {
                const node = nodes[i];
                if (node.nodeName === name) {
                    for (let j = 0; j < node.attributes.length; j += 1) {
                        const attribute = node.attributes[j];
                        if (!attributes[attribute.name])
                            node.removeAttribute(attribute.name);
                    }
                    return nodes.splice(i, 1)[0]; // TODO strip unwanted attributes
                }
            }
            return svg ? svg_element(name) : element(name);
        }
        function claim_text(nodes, data) {
            for (let i = 0; i < nodes.length; i += 1) {
                const node = nodes[i];
                if (node.nodeType === 3) {
                    node.data = '' + data;
                    return nodes.splice(i, 1)[0];
                }
            }
            return text(data);
        }
        function claim_space(nodes) {
            return claim_text(nodes, ' ');
        }
        function set_data(text, data) {
            data = '' + data;
            if (text.data !== data)
                text.data = data;
        }
        function set_input_value(input, value) {
            if (value != null || input.value) {
                input.value = value;
            }
        }
        function set_input_type(input, type) {
            try {
                input.type = type;
            }
            catch (e) {
                // do nothing
            }
        }
        function set_style(node, key, value, important) {
            node.style.setProperty(key, value, important ? 'important' : '');
        }
        function select_option(select, value) {
            for (let i = 0; i < select.options.length; i += 1) {
                const option = select.options[i];
                if (option.__value === value) {
                    option.selected = true;
                    return;
                }
            }
        }
        function select_options(select, value) {
            for (let i = 0; i < select.options.length; i += 1) {
                const option = select.options[i];
                option.selected = ~value.indexOf(option.__value);
            }
        }
        function select_value(select) {
            const selected_option = select.querySelector(':checked') || select.options[0];
            return selected_option && selected_option.__value;
        }
        function select_multiple_value(select) {
            return [].map.call(select.querySelectorAll(':checked'), option => option.__value);
        }
        function add_resize_listener(element, fn) {
            if (getComputedStyle(element).position === 'static') {
                element.style.position = 'relative';
            }
            const object = document.createElement('object');
            object.setAttribute('style', 'display: block; position: absolute; top: 0; left: 0; height: 100%; width: 100%; overflow: hidden; pointer-events: none; z-index: -1;');
            object.setAttribute('aria-hidden', 'true');
            object.type = 'text/html';
            object.tabIndex = -1;
            let win;
            object.onload = () => {
                win = object.contentDocument.defaultView;
                win.addEventListener('resize', fn);
            };
            if (/Trident/.test(navigator.userAgent)) {
                element.appendChild(object);
                object.data = 'about:blank';
            }
            else {
                object.data = 'about:blank';
                element.appendChild(object);
            }
            return {
                cancel: () => {
                    win && win.removeEventListener && win.removeEventListener('resize', fn);
                    element.removeChild(object);
                }
            };
        }
        function toggle_class(element, name, toggle) {
            element.classList[toggle ? 'add' : 'remove'](name);
        }
        function custom_event(type, detail) {
            const e = document.createEvent('CustomEvent');
            e.initCustomEvent(type, false, false, detail);
            return e;
        }
        class HtmlTag {
            constructor(html, anchor = null) {
                this.e = element('div');
                this.a = anchor;
                this.u(html);
            }
            m(target, anchor = null) {
                for (let i = 0; i < this.n.length; i += 1) {
                    insert(target, this.n[i], anchor);
                }
                this.t = target;
            }
            u(html) {
                this.e.innerHTML = html;
                this.n = Array.from(this.e.childNodes);
            }
            p(html) {
                this.d();
                this.u(html);
                this.m(this.t, this.a);
            }
            d() {
                this.n.forEach(detach);
            }
        }

        let stylesheet;
        let active = 0;
        let current_rules = {};
        // https://github.com/darkskyapp/string-hash/blob/master/index.js
        function hash(str) {
            let hash = 5381;
            let i = str.length;
            while (i--)
                hash = ((hash << 5) - hash) ^ str.charCodeAt(i);
            return hash >>> 0;
        }
        function create_rule(node, a, b, duration, delay, ease, fn, uid = 0) {
            const step = 16.666 / duration;
            let keyframes = '{\n';
        for (let p = 0; p <= 1; p += step) {
            const t = a + (b - a) * ease(p);
            keyframes += p * 100 + `%{${fn(t, 1 - t)}}\n`;
        }
        const rule = keyframes + `100% {${fn(b, 1 - b)}}\n}`;
        const name = `__svelte_${hash(rule)}_${uid}`;
        if (!current_rules[name]) {
            if (!stylesheet) {
                const style = element('style');
                document.head.appendChild(style);
                stylesheet = style.sheet;
            }
            current_rules[name] = true;
            stylesheet.insertRule(`@keyframes ${name} ${rule}`, stylesheet.cssRules.length);
        }
        const animation = node.style.animation || '';
        node.style.animation = `${animation ? `${animation}, ` : ``}${name} ${duration}ms linear ${delay}ms 1 both`;
        active += 1;
        return name;
    }
    function delete_rule(node, name) {
        node.style.animation = (node.style.animation || '')
            .split(', ')
            .filter(name
            ? anim => anim.indexOf(name) < 0 // remove specific animation
            : anim => anim.indexOf('__svelte') === -1 // remove all Svelte animations
        )
            .join(', ');
        if (name && !--active)
            clear_rules();
    }
    function clear_rules() {
        raf(() => {
            if (active)
                return;
            let i = stylesheet.cssRules.length;
            while (i--)
                stylesheet.deleteRule(i);
            current_rules = {};
        });
    }

    function create_animation(node, from, fn, params) {
        if (!from)
            return noop;
        const to = node.getBoundingClientRect();
        if (from.left === to.left && from.right === to.right && from.top === to.top && from.bottom === to.bottom)
            return noop;
        const { delay = 0, duration = 300, easing = identity,
        // @ts-ignore todo: should this be separated from destructuring? Or start/end added to public api and documentation?
        start: start_time = now() + delay,
        // @ts-ignore todo:
        end = start_time + duration, tick = noop, css } = fn(node, { from, to }, params);
        let running = true;
        let started = false;
        let name;
        function start() {
            if (css) {
                name = create_rule(node, 0, 1, duration, delay, easing, css);
            }
            if (!delay) {
                started = true;
            }
        }
        function stop() {
            if (css)
                delete_rule(node, name);
            running = false;
        }
        loop(now => {
            if (!started && now >= start_time) {
                started = true;
            }
            if (started && now >= end) {
                tick(1, 0);
                stop();
            }
            if (!running) {
                return false;
            }
            if (started) {
                const p = now - start_time;
                const t = 0 + 1 * easing(p / duration);
                tick(t, 1 - t);
            }
            return true;
        });
        start();
        tick(0, 1);
        return stop;
    }
    function fix_position(node) {
        const style = getComputedStyle(node);
        if (style.position !== 'absolute' && style.position !== 'fixed') {
            const { width, height } = style;
            const a = node.getBoundingClientRect();
            node.style.position = 'absolute';
            node.style.width = width;
            node.style.height = height;
            add_transform(node, a);
        }
    }
    function add_transform(node, a) {
        const b = node.getBoundingClientRect();
        if (a.left !== b.left || a.top !== b.top) {
            const style = getComputedStyle(node);
            const transform = style.transform === 'none' ? '' : style.transform;
            node.style.transform = `${transform} translate(${a.left - b.left}px, ${a.top - b.top}px)`;
        }
    }

    let current_component;
    function set_current_component(component) {
        current_component = component;
    }
    function get_current_component() {
        if (!current_component)
            throw new Error(`Function called outside component initialization`);
        return current_component;
    }
    function beforeUpdate(fn) {
        get_current_component().$$.before_update.push(fn);
    }
    function onMount(fn) {
        get_current_component().$$.on_mount.push(fn);
    }
    function afterUpdate(fn) {
        get_current_component().$$.after_update.push(fn);
    }
    function onDestroy(fn) {
        get_current_component().$$.on_destroy.push(fn);
    }
    function createEventDispatcher() {
        const component = get_current_component();
        return (type, detail) => {
            const callbacks = component.$$.callbacks[type];
            if (callbacks) {
                // TODO are there situations where events could be dispatched
                // in a server (non-DOM) environment?
                const event = custom_event(type, detail);
                callbacks.slice().forEach(fn => {
                    fn.call(component, event);
                });
            }
        };
    }
    function setContext(key, context) {
        get_current_component().$$.context.set(key, context);
    }
    function getContext(key) {
        return get_current_component().$$.context.get(key);
    }
    // TODO figure out if we still want to support
    // shorthand events, or if we want to implement
    // a real bubbling mechanism
    function bubble(component, event) {
        const callbacks = component.$$.callbacks[event.type];
        if (callbacks) {
            callbacks.slice().forEach(fn => fn(event));
        }
    }

    const dirty_components = [];
    const intros = { enabled: false };
    const binding_callbacks = [];
    const render_callbacks = [];
    const flush_callbacks = [];
    const resolved_promise = Promise.resolve();
    let update_scheduled = false;
    function schedule_update() {
        if (!update_scheduled) {
            update_scheduled = true;
            resolved_promise.then(flush);
        }
    }
    function tick() {
        schedule_update();
        return resolved_promise;
    }
    function add_render_callback(fn) {
        render_callbacks.push(fn);
    }
    function add_flush_callback(fn) {
        flush_callbacks.push(fn);
    }
    function flush() {
        const seen_callbacks = new Set();
        do {
            // first, call beforeUpdate functions
            // and update components
            while (dirty_components.length) {
                const component = dirty_components.shift();
                set_current_component(component);
                update(component.$$);
            }
            while (binding_callbacks.length)
                binding_callbacks.pop()();
            // then, once components are updated, call
            // afterUpdate functions. This may cause
            // subsequent updates...
            for (let i = 0; i < render_callbacks.length; i += 1) {
                const callback = render_callbacks[i];
                if (!seen_callbacks.has(callback)) {
                    callback();
                    // ...so guard against infinite loops
                    seen_callbacks.add(callback);
                }
            }
            render_callbacks.length = 0;
        } while (dirty_components.length);
        while (flush_callbacks.length) {
            flush_callbacks.pop()();
        }
        update_scheduled = false;
    }
    function update($$) {
        if ($$.fragment !== null) {
            $$.update();
            run_all($$.before_update);
            const dirty = $$.dirty;
            $$.dirty = [-1];
            $$.fragment && $$.fragment.p($$.ctx, dirty);
            $$.after_update.forEach(add_render_callback);
        }
    }

    let promise;
    function wait() {
        if (!promise) {
            promise = Promise.resolve();
            promise.then(() => {
                promise = null;
            });
        }
        return promise;
    }
    function dispatch(node, direction, kind) {
        node.dispatchEvent(custom_event(`${direction ? 'intro' : 'outro'}${kind}`));
    }
    const outroing = new Set();
    let outros;
    function group_outros() {
        outros = {
            r: 0,
            c: [],
            p: outros // parent group
        };
    }
    function check_outros() {
        if (!outros.r) {
            run_all(outros.c);
        }
        outros = outros.p;
    }
    function transition_in(block, local) {
        if (block && block.i) {
            outroing.delete(block);
            block.i(local);
        }
    }
    function transition_out(block, local, detach, callback) {
        if (block && block.o) {
            if (outroing.has(block))
                return;
            outroing.add(block);
            outros.c.push(() => {
                outroing.delete(block);
                if (callback) {
                    if (detach)
                        block.d(1);
                    callback();
                }
            });
            block.o(local);
        }
    }
    const null_transition = { duration: 0 };
    function create_in_transition(node, fn, params) {
        let config = fn(node, params);
        let running = false;
        let animation_name;
        let task;
        let uid = 0;
        function cleanup() {
            if (animation_name)
                delete_rule(node, animation_name);
        }
        function go() {
            const { delay = 0, duration = 300, easing = identity, tick = noop, css } = config || null_transition;
            if (css)
                animation_name = create_rule(node, 0, 1, duration, delay, easing, css, uid++);
            tick(0, 1);
            const start_time = now() + delay;
            const end_time = start_time + duration;
            if (task)
                task.abort();
            running = true;
            add_render_callback(() => dispatch(node, true, 'start'));
            task = loop(now => {
                if (running) {
                    if (now >= end_time) {
                        tick(1, 0);
                        dispatch(node, true, 'end');
                        cleanup();
                        return running = false;
                    }
                    if (now >= start_time) {
                        const t = easing((now - start_time) / duration);
                        tick(t, 1 - t);
                    }
                }
                return running;
            });
        }
        let started = false;
        return {
            start() {
                if (started)
                    return;
                delete_rule(node);
                if (is_function(config)) {
                    config = config();
                    wait().then(go);
                }
                else {
                    go();
                }
            },
            invalidate() {
                started = false;
            },
            end() {
                if (running) {
                    cleanup();
                    running = false;
                }
            }
        };
    }
    function create_out_transition(node, fn, params) {
        let config = fn(node, params);
        let running = true;
        let animation_name;
        const group = outros;
        group.r += 1;
        function go() {
            const { delay = 0, duration = 300, easing = identity, tick = noop, css } = config || null_transition;
            if (css)
                animation_name = create_rule(node, 1, 0, duration, delay, easing, css);
            const start_time = now() + delay;
            const end_time = start_time + duration;
            add_render_callback(() => dispatch(node, false, 'start'));
            loop(now => {
                if (running) {
                    if (now >= end_time) {
                        tick(0, 1);
                        dispatch(node, false, 'end');
                        if (!--group.r) {
                            // this will result in `end()` being called,
                            // so we don't need to clean up here
            run_all(group.c);
            }
            return false;
        }
        if (now >= start_time) {
            const t = easing((now - start_time) / duration);
            tick(1 - t, t);
        }
    }
    return running;
    });
    }
    if (is_function(config)) {
        wait().then(() => {
            // @ts-ignore
            config = config();
            go();
        });
    }
    else {
        go();
    }
    return {
        end(reset) {
            if (reset && config.tick) {
                config.tick(1, 0);
            }
            if (running) {
                if (animation_name)
                    delete_rule(node, animation_name);
                running = false;
            }
        }
    };
    }
    function create_bidirectional_transition(node, fn, params, intro) {
        let config = fn(node, params);
        let t = intro ? 0 : 1;
        let running_program = null;
        let pending_program = null;
        let animation_name = null;
        function clear_animation() {
            if (animation_name)
                delete_rule(node, animation_name);
        }
        function init(program, duration) {
            const d = program.b - t;
            duration *= Math.abs(d);
            return {
                a: t,
                b: program.b,
                d,
                duration,
                start: program.start,
                end: program.start + duration,
                group: program.group
            };
        }
        function go(b) {
            const { delay = 0, duration = 300, easing = identity, tick = noop, css } = config || null_transition;
            const program = {
                start: now() + delay,
                b
            };
            if (!b) {
                // @ts-ignore todo: improve typings
                program.group = outros;
                outros.r += 1;
            }
            if (running_program) {
                pending_program = program;
            }
            else {
                // if this is an intro, and there's a delay, we need to do
                // an initial tick and/or apply CSS animation immediately
                if (css) {
                    clear_animation();
                    animation_name = create_rule(node, t, b, duration, delay, easing, css);
                }
                if (b)
                    tick(0, 1);
                running_program = init(program, duration);
                add_render_callback(() => dispatch(node, b, 'start'));
                loop(now => {
                    if (pending_program && now > pending_program.start) {
                        running_program = init(pending_program, duration);
                        pending_program = null;
                        dispatch(node, running_program.b, 'start');
                        if (css) {
                            clear_animation();
                            animation_name = create_rule(node, t, running_program.b, running_program.duration, 0, easing, config.css);
                        }
                    }
                    if (running_program) {
                        if (now >= running_program.end) {
                            tick(t = running_program.b, 1 - t);
                            dispatch(node, running_program.b, 'end');
                            if (!pending_program) {
                                // we're done
                                if (running_program.b) {
                                    // intro — we can tidy up immediately
                                    clear_animation();
                                }
                                else {
                                    // outro — needs to be coordinated
                                    if (!--running_program.group.r)
                                        run_all(running_program.group.c);
                                }
                            }
                            running_program = null;
                        }
                        else if (now >= running_program.start) {
                            const p = now - running_program.start;
                            t = running_program.a + running_program.d * easing(p / running_program.duration);
                            tick(t, 1 - t);
                        }
                    }
                    return !!(running_program || pending_program);
                });
            }
        }
        return {
            run(b) {
                if (is_function(config)) {
                    wait().then(() => {
                        // @ts-ignore
                        config = config();
                        go(b);
                    });
                }
                else {
                    go(b);
                }
            },
            end() {
                clear_animation();
                running_program = pending_program = null;
            }
        };
    }

    function handle_promise(promise, info) {
        const token = info.token = {};
        function update(type, index, key, value) {
            if (info.token !== token)
                return;
            info.resolved = value;
            let child_ctx = info.ctx;
            if (key !== undefined) {
                child_ctx = child_ctx.slice();
                child_ctx[key] = value;
            }
            const block = type && (info.current = type)(child_ctx);
            let needs_flush = false;
            if (info.block) {
                if (info.blocks) {
                    info.blocks.forEach((block, i) => {
                        if (i !== index && block) {
                            group_outros();
                            transition_out(block, 1, 1, () => {
                                info.blocks[i] = null;
                            });
                            check_outros();
                        }
                    });
                }
                else {
                    info.block.d(1);
                }
                block.c();
                transition_in(block, 1);
                block.m(info.mount(), info.anchor);
                needs_flush = true;
            }
            info.block = block;
            if (info.blocks)
                info.blocks[index] = block;
            if (needs_flush) {
                flush();
            }
        }
        if (is_promise(promise)) {
            const current_component = get_current_component();
            promise.then(value => {
                set_current_component(current_component);
                update(info.then, 1, info.value, value);
                set_current_component(null);
            }, error => {
                set_current_component(current_component);
                update(info.catch, 2, info.error, error);
                set_current_component(null);
            });
            // if we previously had a then/catch block, destroy it
            if (info.current !== info.pending) {
                update(info.pending, 0);
                return true;
            }
        }
        else {
            if (info.current !== info.then) {
                update(info.then, 1, info.value, promise);
                return true;
            }
            info.resolved = promise;
        }
    }

    const globals = (typeof window !== 'undefined' ? window : global);

    function destroy_block(block, lookup) {
        block.d(1);
        lookup.delete(block.key);
    }
    function outro_and_destroy_block(block, lookup) {
        transition_out(block, 1, 1, () => {
            lookup.delete(block.key);
        });
    }
    function fix_and_destroy_block(block, lookup) {
        block.f();
        destroy_block(block, lookup);
    }
    function fix_and_outro_and_destroy_block(block, lookup) {
        block.f();
        outro_and_destroy_block(block, lookup);
    }
    function update_keyed_each(old_blocks, dirty, get_key, dynamic, ctx, list, lookup, node, destroy, create_each_block, next, get_context) {
        let o = old_blocks.length;
        let n = list.length;
        let i = o;
        const old_indexes = {};
        while (i--)
            old_indexes[old_blocks[i].key] = i;
        const new_blocks = [];
        const new_lookup = new Map();
        const deltas = new Map();
        i = n;
        while (i--) {
            const child_ctx = get_context(ctx, list, i);
            const key = get_key(child_ctx);
            let block = lookup.get(key);
            if (!block) {
                block = create_each_block(key, child_ctx);
                block.c();
            }
            else if (dynamic) {
                block.p(child_ctx, dirty);
            }
            new_lookup.set(key, new_blocks[i] = block);
            if (key in old_indexes)
                deltas.set(key, Math.abs(i - old_indexes[key]));
        }
        const will_move = new Set();
        const did_move = new Set();
        function insert(block) {
            transition_in(block, 1);
            block.m(node, next);
            lookup.set(block.key, block);
            next = block.first;
            n--;
        }
        while (o && n) {
            const new_block = new_blocks[n - 1];
            const old_block = old_blocks[o - 1];
            const new_key = new_block.key;
            const old_key = old_block.key;
            if (new_block === old_block) {
                // do nothing
                next = new_block.first;
                o--;
                n--;
            }
            else if (!new_lookup.has(old_key)) {
                // remove old block
                destroy(old_block, lookup);
                o--;
            }
            else if (!lookup.has(new_key) || will_move.has(new_key)) {
                insert(new_block);
            }
            else if (did_move.has(old_key)) {
                o--;
            }
            else if (deltas.get(new_key) > deltas.get(old_key)) {
                did_move.add(new_key);
                insert(new_block);
            }
            else {
                will_move.add(old_key);
                o--;
            }
        }
        while (o--) {
            const old_block = old_blocks[o];
            if (!new_lookup.has(old_block.key))
                destroy(old_block, lookup);
        }
        while (n)
            insert(new_blocks[n - 1]);
        return new_blocks;
    }
    function measure(blocks) {
        const rects = {};
        let i = blocks.length;
        while (i--)
            rects[blocks[i].key] = blocks[i].node.getBoundingClientRect();
        return rects;
    }

    function get_spread_update(levels, updates) {
        const update = {};
        const to_null_out = {};
        const accounted_for = { $$scope: 1 };
        let i = levels.length;
        while (i--) {
            const o = levels[i];
            const n = updates[i];
            if (n) {
                for (const key in o) {
                    if (!(key in n))
                        to_null_out[key] = 1;
                }
                for (const key in n) {
                    if (!accounted_for[key]) {
                        update[key] = n[key];
                        accounted_for[key] = 1;
                    }
                }
                levels[i] = n;
            }
            else {
                for (const key in o) {
                    accounted_for[key] = 1;
                }
            }
        }
        for (const key in to_null_out) {
            if (!(key in update))
                update[key] = undefined;
        }
        return update;
    }
    function get_spread_object(spread_props) {
        return typeof spread_props === 'object' && spread_props !== null ? spread_props : {};
    }

    // source: https://html.spec.whatwg.org/multipage/indices.html
    const boolean_attributes = new Set([
        'allowfullscreen',
        'allowpaymentrequest',
        'async',
        'autofocus',
        'autoplay',
        'checked',
        'controls',
        'default',
        'defer',
        'disabled',
        'formnovalidate',
        'hidden',
        'ismap',
        'loop',
        'multiple',
        'muted',
        'nomodule',
        'novalidate',
        'open',
        'playsinline',
        'readonly',
        'required',
        'reversed',
        'selected'
    ]);

    const invalid_attribute_name_character = /[\s'">/=\u{FDD0}-\u{FDEF}\u{FFFE}\u{FFFF}\u{1FFFE}\u{1FFFF}\u{2FFFE}\u{2FFFF}\u{3FFFE}\u{3FFFF}\u{4FFFE}\u{4FFFF}\u{5FFFE}\u{5FFFF}\u{6FFFE}\u{6FFFF}\u{7FFFE}\u{7FFFF}\u{8FFFE}\u{8FFFF}\u{9FFFE}\u{9FFFF}\u{AFFFE}\u{AFFFF}\u{BFFFE}\u{BFFFF}\u{CFFFE}\u{CFFFF}\u{DFFFE}\u{DFFFF}\u{EFFFE}\u{EFFFF}\u{FFFFE}\u{FFFFF}\u{10FFFE}\u{10FFFF}]/u;
    // https://html.spec.whatwg.org/multipage/syntax.html#attributes-2
    // https://infra.spec.whatwg.org/#noncharacter
    function spread(args, classes_to_add) {
        const attributes = Object.assign({}, ...args);
        if (classes_to_add) {
            if (attributes.class == null) {
                attributes.class = classes_to_add;
            }
            else {
                attributes.class += ' ' + classes_to_add;
            }
        }
        let str = '';
        Object.keys(attributes).forEach(name => {
            if (invalid_attribute_name_character.test(name))
                return;
            const value = attributes[name];
            if (value === true)
                str += " " + name;
            else if (boolean_attributes.has(name.toLowerCase())) {
                if (value)
                    str += " " + name;
            }
            else if (value != null) {
                str += " " + name + "=" + JSON.stringify(String(value)
                    .replace(/"/g, '&#34;')
                    .replace(/'/g, '&#39;'));
            }
        });
        return str;
    }
    const escaped = {
        '"': '&quot;',
        "'": '&#39;',
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;'
    };
    function escape$1(html) {
        return String(html).replace(/["'&<>]/g, match => escaped[match]);
    }
    function each(items, fn) {
        let str = '';
        for (let i = 0; i < items.length; i += 1) {
            str += fn(items[i], i);
        }
        return str;
    }
    const missing_component = {
        $$render: () => ''
    };
    function validate_component(component, name) {
        if (!component || !component.$$render) {
            if (name === 'svelte:component')
                name += ' this={...}';
            throw new Error(`<${name}> is not a valid SSR component. You may need to review your build config to ensure that dependencies are compiled, rather than imported as pre-compiled modules`);
        }
        return component;
    }
    function debug(file, line, column, values) {
        console.log(`{@debug} ${file ? file + ' ' : ''}(${line}:${column})`); // eslint-disable-line no-console
        console.log(values); // eslint-disable-line no-console
        return '';
    }
    let on_destroy;
    function create_ssr_component(fn) {
        function $$render(result, props, bindings, slots) {
            const parent_component = current_component;
            const $$ = {
                on_destroy,
                context: new Map(parent_component ? parent_component.$$.context : []),
                // these will be immediately discarded
                on_mount: [],
                before_update: [],
                after_update: [],
                callbacks: blank_object()
            };
            set_current_component({ $$ });
            const html = fn(result, props, bindings, slots);
            set_current_component(parent_component);
            return html;
        }
        return {
            render: (props = {}, options = {}) => {
                on_destroy = [];
                const result = { head: '', css: new Set() };
                const html = $$render(result, props, {}, options);
                run_all(on_destroy);
                return {
                    html,
                    css: {
                        code: Array.from(result.css).map(css => css.code).join('\n'),
                        map: null // TODO
                    },
                    head: result.head
                };
            },
            $$render
        };
    }
    function add_attribute(name, value, boolean) {
        if (value == null || (boolean && !value))
            return '';
        return ` ${name}${value === true ? '' : `=${typeof value === 'string' ? JSON.stringify(escape$1(value)) : `"${value}"`}`}`;
    }
    function add_classes(classes) {
        return classes ? ` class="${classes}"` : ``;
    }

    function bind(component, name, callback) {
        const index = component.$$.props[name];
        if (index !== undefined) {
            component.$$.bound[index] = callback;
            callback(component.$$.ctx[index]);
        }
    }
    function create_component(block) {
        block && block.c();
    }
    function claim_component(block, parent_nodes) {
        block && block.l(parent_nodes);
    }
    function mount_component(component, target, anchor) {
        const { fragment, on_mount, on_destroy, after_update } = component.$$;
        fragment && fragment.m(target, anchor);
        // onMount happens before the initial afterUpdate
        add_render_callback(() => {
            const new_on_destroy = on_mount.map(run).filter(is_function);
            if (on_destroy) {
                on_destroy.push(...new_on_destroy);
            }
            else {
                // Edge case - component was destroyed immediately,
                // most likely as a result of a binding initialising
                run_all(new_on_destroy);
            }
            component.$$.on_mount = [];
        });
        after_update.forEach(add_render_callback);
    }
    function destroy_component(component, detaching) {
        const $$ = component.$$;
        if ($$.fragment !== null) {
            run_all($$.on_destroy);
            $$.fragment && $$.fragment.d(detaching);
            // TODO null out other refs, including component.$$ (but need to
            // preserve final state?)
            $$.on_destroy = $$.fragment = null;
            $$.ctx = [];
        }
    }
    function make_dirty(component, i) {
        if (component.$$.dirty[0] === -1) {
            dirty_components.push(component);
            schedule_update();
            component.$$.dirty.fill(0);
        }
        component.$$.dirty[(i / 31) | 0] |= (1 << (i % 31));
    }
    function init(component, options, instance, create_fragment, not_equal, props, dirty = [-1]) {
        const parent_component = current_component;
        set_current_component(component);
        const prop_values = options.props || {};
        const $$ = component.$$ = {
            fragment: null,
            ctx: null,
            // state
            props,
            update: noop,
            not_equal,
            bound: blank_object(),
            // lifecycle
            on_mount: [],
            on_destroy: [],
            before_update: [],
            after_update: [],
            context: new Map(parent_component ? parent_component.$$.context : []),
            // everything else
            callbacks: blank_object(),
            dirty
        };
        let ready = false;
        $$.ctx = instance
            ? instance(component, prop_values, (i, ret, value = ret) => {
                if ($$.ctx && not_equal($$.ctx[i], $$.ctx[i] = value)) {
                    if ($$.bound[i])
                        $$.bound[i](value);
                    if (ready)
                        make_dirty(component, i);
                }
                return ret;
            })
            : [];
        $$.update();
        ready = true;
        run_all($$.before_update);
        // `false` as a special case of no DOM component
        $$.fragment = create_fragment ? create_fragment($$.ctx) : false;
        if (options.target) {
            if (options.hydrate) {
                // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
                $$.fragment && $$.fragment.l(children(options.target));
            }
            else {
                // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
                $$.fragment && $$.fragment.c();
            }
            if (options.intro)
                transition_in(component.$$.fragment);
            mount_component(component, options.target, options.anchor);
            flush();
        }
        set_current_component(parent_component);
    }
    let SvelteElement;
    if (typeof HTMLElement === 'function') {
        SvelteElement = class extends HTMLElement {
            constructor() {
                super();
                this.attachShadow({ mode: 'open' });
            }
            connectedCallback() {
                // @ts-ignore todo: improve typings
                for (const key in this.$$.slotted) {
                    // @ts-ignore todo: improve typings
                    this.appendChild(this.$$.slotted[key]);
                }
            }
            attributeChangedCallback(attr, _oldValue, newValue) {
                this[attr] = newValue;
            }
            $destroy() {
                destroy_component(this, 1);
                this.$destroy = noop;
            }
            $on(type, callback) {
                // TODO should this delegate to addEventListener?
                const callbacks = (this.$$.callbacks[type] || (this.$$.callbacks[type] = []));
                callbacks.push(callback);
                return () => {
                    const index = callbacks.indexOf(callback);
                    if (index !== -1)
                        callbacks.splice(index, 1);
                };
            }
            $set() {
                // overridden by instance, if it has props
            }
        };
    }
    class SvelteComponent {
        $destroy() {
            destroy_component(this, 1);
            this.$destroy = noop;
        }
        $on(type, callback) {
            const callbacks = (this.$$.callbacks[type] || (this.$$.callbacks[type] = []));
            callbacks.push(callback);
            return () => {
                const index = callbacks.indexOf(callback);
                if (index !== -1)
                    callbacks.splice(index, 1);
            };
        }
        $set() {
            // overridden by instance, if it has props
        }
    }

    function dispatch_dev(type, detail) {
        document.dispatchEvent(custom_event(type, detail));
    }
    function append_dev(target, node) {
        dispatch_dev("SvelteDOMInsert", { target, node });
        append(target, node);
    }
    function insert_dev(target, node, anchor) {
        dispatch_dev("SvelteDOMInsert", { target, node, anchor });
        insert(target, node, anchor);
    }
    function detach_dev(node) {
        dispatch_dev("SvelteDOMRemove", { node });
        detach(node);
    }
    function detach_between_dev(before, after) {
        while (before.nextSibling && before.nextSibling !== after) {
            detach_dev(before.nextSibling);
        }
    }
    function detach_before_dev(after) {
        while (after.previousSibling) {
            detach_dev(after.previousSibling);
        }
    }
    function detach_after_dev(before) {
        while (before.nextSibling) {
            detach_dev(before.nextSibling);
        }
    }
    function listen_dev(node, event, handler, options, has_prevent_default, has_stop_propagation) {
        const modifiers = options === true ? ["capture"] : options ? Array.from(Object.keys(options)) : [];
        if (has_prevent_default)
            modifiers.push('preventDefault');
        if (has_stop_propagation)
            modifiers.push('stopPropagation');
        dispatch_dev("SvelteDOMAddEventListener", { node, event, handler, modifiers });
        const dispose = listen(node, event, handler, options);
        return () => {
            dispatch_dev("SvelteDOMRemoveEventListener", { node, event, handler, modifiers });
            dispose();
        };
    }
    function attr_dev(node, attribute, value) {
        attr(node, attribute, value);
        if (value == null)
            dispatch_dev("SvelteDOMRemoveAttribute", { node, attribute });
        else
            dispatch_dev("SvelteDOMSetAttribute", { node, attribute, value });
    }
    function prop_dev(node, property, value) {
        node[property] = value;
        dispatch_dev("SvelteDOMSetProperty", { node, property, value });
    }
    function dataset_dev(node, property, value) {
        node.dataset[property] = value;
        dispatch_dev("SvelteDOMSetDataset", { node, property, value });
    }
    function set_data_dev(text, data) {
        data = '' + data;
        if (text.data === data)
            return;
        dispatch_dev("SvelteDOMSetData", { node: text, data });
        text.data = data;
    }
    class SvelteComponentDev extends SvelteComponent {
        constructor(options) {
            if (!options || (!options.target && !options.$$inline)) {
                throw new Error(`'target' is a required option`);
            }
            super();
        }
        $destroy() {
            super.$destroy();
            this.$destroy = () => {
                console.warn(`Component was already destroyed`); // eslint-disable-line no-console
            };
        }
    }
    function loop_guard(timeout) {
        const start = Date.now();
        return () => {
            if (Date.now() - start > timeout) {
                throw new Error(`Infinite loop detected`);
            }
        };
    }

    'use strict';

    var has = Object.prototype.hasOwnProperty
        , undef;

    /**
     * Decode a URI encoded string.
     *
     * @param {String} input The URI encoded string.
     * @returns {String|Null} The decoded string.
     * @api private
     */
    function decode(input) {
        try {
            return decodeURIComponent(input.replace(/\+/g, ' '));
        } catch (e) {
            return null;
        }
    }

    /**
     * Attempts to encode a given input.
     *
     * @param {String} input The string that needs to be encoded.
     * @returns {String|Null} The encoded string.
     * @api private
     */
    function encode(input) {
        try {
            return encodeURIComponent(input);
        } catch (e) {
            return null;
        }
    }

    /**
     * Simple query string parser.
     *
     * @param {String} query The query string that needs to be parsed.
     * @returns {Object}
     * @api public
     */
    function querystring(query) {
        var parser = /([^=?&]+)=?([^&]*)/g
            , result = {}
            , part;

        while (part = parser.exec(query)) {
            var key = decode(part[1])
                , value = decode(part[2]);

            //
            // Prevent overriding of existing properties. This ensures that build-in
            // methods like `toString` or __proto__ are not overriden by malicious
            // querystrings.
            //
            // In the case if failed decoding, we want to omit the key/value pairs
            // from the result.
            //
            if (key === null || value === null || key in result) continue;
            result[key] = value;
        }

        return result;
    }

    /**
     * Transform a query string to an object.
     *
     * @param {Object} obj Object that should be transformed.
     * @param {String} prefix Optional prefix.
     * @returns {String}
     * @api public
     */
    function querystringify(obj, prefix) {
        prefix = prefix || '';

        var pairs = []
            , value
            , key;

        //
        // Optionally prefix with a '?' if needed
        //
        if ('string' !== typeof prefix) prefix = '?';

        for (key in obj) {
            if (has.call(obj, key)) {
                value = obj[key];

                //
                // Edge cases where we actually want to encode the value to an empty
                // string instead of the stringified value.
                //
                if (!value && (value === null || value === undef || isNaN(value))) {
                    value = '';
                }

                key = encodeURIComponent(key);
                value = encodeURIComponent(value);

                //
                // If we failed to encode the strings, we should bail out as we don't
                // want to add invalid strings to the query.
                //
                if (key === null || value === null) continue;
                pairs.push(key +'='+ value);
            }
        }

        return pairs.length ? prefix + pairs.join('&') : '';
    }

    //
    // Expose the module.
    //
    var stringify = querystringify;
    var parse = querystring;

    var querystringify_1 = {
        stringify: stringify,
        parse: parse
    };

    var commonjsGlobal = typeof globalThis !== 'undefined' ? globalThis : typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : typeof self !== 'undefined' ? self : {};

    function commonjsRequire () {
        throw new Error('Dynamic requires are not currently supported by @rollup/plugin-commonjs');
    }

    function unwrapExports (x) {
        return x && x.__esModule && Object.prototype.hasOwnProperty.call(x, 'default') ? x['default'] : x;
    }

    function createCommonjsModule(fn, module) {
        return module = { exports: {} }, fn(module, module.exports), module.exports;
    }

    function getCjsExportFromNamespace (n) {
        return n && n['default'] || n;
    }

    var core = createCommonjsModule(function (module, exports) {
        ;(function (root, factory) {
            if ('object' === "object") {
                // CommonJS
                module.exports = exports = factory();
            }
            else if (typeof undefined === "function" && undefined.amd) {
                // AMD
                undefined([], factory);
            }
            else {
                // Global (browser)
                root.CryptoJS = factory();
            }
        }(commonjsGlobal, function () {

            /**
             * CryptoJS core components.
             */
            var CryptoJS = CryptoJS || (function (Math, undefined$1) {
                /*
    	     * Local polyfil of Object.create
    	     */
                var create = Object.create || (function () {
                    function F() {};

                    return function (obj) {
                        var subtype;

                        F.prototype = obj;

                        subtype = new F();

                        F.prototype = null;

                        return subtype;
                    };
                }());

                /**
                 * CryptoJS namespace.
                 */
                var C = {};

                /**
                 * Library namespace.
                 */
                var C_lib = C.lib = {};

                /**
                 * Base object for prototypal inheritance.
                 */
                var Base = C_lib.Base = (function () {


                    return {
                        /**
                         * Creates a new object that inherits from this object.
                         *
                         * @param {Object} overrides Properties to copy into the new object.
                         *
                         * @return {Object} The new object.
                         *
                         * @static
                         *
                         * @example
                         *
                         *     var MyType = CryptoJS.lib.Base.extend({
                         *         field: 'value',
                         *
                         *         method: function () {
                         *         }
                         *     });
                         */
                        extend: function (overrides) {
                            // Spawn
                            var subtype = create(this);

                            // Augment
                            if (overrides) {
                                subtype.mixIn(overrides);
                            }

                            // Create default initializer
                            if (!subtype.hasOwnProperty('init') || this.init === subtype.init) {
                                subtype.init = function () {
                                    subtype.$super.init.apply(this, arguments);
                                };
                            }

                            // Initializer's prototype is the subtype object
                            subtype.init.prototype = subtype;

                            // Reference supertype
                            subtype.$super = this;

                            return subtype;
                        },

                        /**
                         * Extends this object and runs the init method.
                         * Arguments to create() will be passed to init().
                         *
                         * @return {Object} The new object.
                         *
                         * @static
                         *
                         * @example
                         *
                         *     var instance = MyType.create();
                         */
                        create: function () {
                            var instance = this.extend();
                            instance.init.apply(instance, arguments);

                            return instance;
                        },

                        /**
                         * Initializes a newly created object.
                         * Override this method to add some logic when your objects are created.
                         *
                         * @example
                         *
                         *     var MyType = CryptoJS.lib.Base.extend({
                         *         init: function () {
                         *             // ...
                         *         }
                         *     });
                         */
                        init: function () {
                        },

                        /**
                         * Copies properties into this object.
                         *
                         * @param {Object} properties The properties to mix in.
                         *
                         * @example
                         *
                         *     MyType.mixIn({
                         *         field: 'value'
                         *     });
                         */
                        mixIn: function (properties) {
                            for (var propertyName in properties) {
                                if (properties.hasOwnProperty(propertyName)) {
                                    this[propertyName] = properties[propertyName];
                                }
                            }

                            // IE won't copy toString using the loop above
                            if (properties.hasOwnProperty('toString')) {
                                this.toString = properties.toString;
                            }
                        },

                        /**
                         * Creates a copy of this object.
                         *
                         * @return {Object} The clone.
                         *
                         * @example
                         *
                         *     var clone = instance.clone();
                         */
                        clone: function () {
                            return this.init.prototype.extend(this);
                        }
                    };
                }());

                /**
                 * An array of 32-bit words.
                 *
                 * @property {Array} words The array of 32-bit words.
                 * @property {number} sigBytes The number of significant bytes in this word array.
                 */
                var WordArray = C_lib.WordArray = Base.extend({
                    /**
                     * Initializes a newly created word array.
                     *
                     * @param {Array} words (Optional) An array of 32-bit words.
                     * @param {number} sigBytes (Optional) The number of significant bytes in the words.
                     *
                     * @example
                     *
                     *     var wordArray = CryptoJS.lib.WordArray.create();
                     *     var wordArray = CryptoJS.lib.WordArray.create([0x00010203, 0x04050607]);
                     *     var wordArray = CryptoJS.lib.WordArray.create([0x00010203, 0x04050607], 6);
                     */
                    init: function (words, sigBytes) {
                        words = this.words = words || [];

                        if (sigBytes != undefined$1) {
                            this.sigBytes = sigBytes;
                        } else {
                            this.sigBytes = words.length * 4;
                        }
                    },

                    /**
                     * Converts this word array to a string.
                     *
                     * @param {Encoder} encoder (Optional) The encoding strategy to use. Default: CryptoJS.enc.Hex
                     *
                     * @return {string} The stringified word array.
                     *
                     * @example
                     *
                     *     var string = wordArray + '';
                     *     var string = wordArray.toString();
                     *     var string = wordArray.toString(CryptoJS.enc.Utf8);
                     */
                    toString: function (encoder) {
                        return (encoder || Hex).stringify(this);
                    },

                    /**
                     * Concatenates a word array to this word array.
                     *
                     * @param {WordArray} wordArray The word array to append.
                     *
                     * @return {WordArray} This word array.
                     *
                     * @example
                     *
                     *     wordArray1.concat(wordArray2);
                     */
                    concat: function (wordArray) {
                        // Shortcuts
                        var thisWords = this.words;
                        var thatWords = wordArray.words;
                        var thisSigBytes = this.sigBytes;
                        var thatSigBytes = wordArray.sigBytes;

                        // Clamp excess bits
                        this.clamp();

                        // Concat
                        if (thisSigBytes % 4) {
                            // Copy one byte at a time
                            for (var i = 0; i < thatSigBytes; i++) {
                                var thatByte = (thatWords[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff;
                                thisWords[(thisSigBytes + i) >>> 2] |= thatByte << (24 - ((thisSigBytes + i) % 4) * 8);
                            }
                        } else {
                            // Copy one word at a time
                            for (var i = 0; i < thatSigBytes; i += 4) {
                                thisWords[(thisSigBytes + i) >>> 2] = thatWords[i >>> 2];
                            }
                        }
                        this.sigBytes += thatSigBytes;

                        // Chainable
                        return this;
                    },

                    /**
                     * Removes insignificant bits.
                     *
                     * @example
                     *
                     *     wordArray.clamp();
                     */
                    clamp: function () {
                        // Shortcuts
                        var words = this.words;
                        var sigBytes = this.sigBytes;

                        // Clamp
                        words[sigBytes >>> 2] &= 0xffffffff << (32 - (sigBytes % 4) * 8);
                        words.length = Math.ceil(sigBytes / 4);
                    },

                    /**
                     * Creates a copy of this word array.
                     *
                     * @return {WordArray} The clone.
                     *
                     * @example
                     *
                     *     var clone = wordArray.clone();
                     */
                    clone: function () {
                        var clone = Base.clone.call(this);
                        clone.words = this.words.slice(0);

                        return clone;
                    },

                    /**
                     * Creates a word array filled with random bytes.
                     *
                     * @param {number} nBytes The number of random bytes to generate.
                     *
                     * @return {WordArray} The random word array.
                     *
                     * @static
                     *
                     * @example
                     *
                     *     var wordArray = CryptoJS.lib.WordArray.random(16);
                     */
                    random: function (nBytes) {
                        var words = [];

                        var r = (function (m_w) {
                            var m_w = m_w;
                            var m_z = 0x3ade68b1;
                            var mask = 0xffffffff;

                            return function () {
                                m_z = (0x9069 * (m_z & 0xFFFF) + (m_z >> 0x10)) & mask;
                                m_w = (0x4650 * (m_w & 0xFFFF) + (m_w >> 0x10)) & mask;
                                var result = ((m_z << 0x10) + m_w) & mask;
                                result /= 0x100000000;
                                result += 0.5;
                                return result * (Math.random() > .5 ? 1 : -1);
                            }
                        });

                        for (var i = 0, rcache; i < nBytes; i += 4) {
                            var _r = r((rcache || Math.random()) * 0x100000000);

                            rcache = _r() * 0x3ade67b7;
                            words.push((_r() * 0x100000000) | 0);
                        }

                        return new WordArray.init(words, nBytes);
                    }
                });

                /**
                 * Encoder namespace.
                 */
                var C_enc = C.enc = {};

                /**
                 * Hex encoding strategy.
                 */
                var Hex = C_enc.Hex = {
                    /**
                     * Converts a word array to a hex string.
                     *
                     * @param {WordArray} wordArray The word array.
                     *
                     * @return {string} The hex string.
                     *
                     * @static
                     *
                     * @example
                     *
                     *     var hexString = CryptoJS.enc.Hex.stringify(wordArray);
                     */
                    stringify: function (wordArray) {
                        // Shortcuts
                        var words = wordArray.words;
                        var sigBytes = wordArray.sigBytes;

                        // Convert
                        var hexChars = [];
                        for (var i = 0; i < sigBytes; i++) {
                            var bite = (words[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff;
                            hexChars.push((bite >>> 4).toString(16));
                            hexChars.push((bite & 0x0f).toString(16));
                        }

                        return hexChars.join('');
                    },

                    /**
                     * Converts a hex string to a word array.
                     *
                     * @param {string} hexStr The hex string.
                     *
                     * @return {WordArray} The word array.
                     *
                     * @static
                     *
                     * @example
                     *
                     *     var wordArray = CryptoJS.enc.Hex.parse(hexString);
                     */
                    parse: function (hexStr) {
                        // Shortcut
                        var hexStrLength = hexStr.length;

                        // Convert
                        var words = [];
                        for (var i = 0; i < hexStrLength; i += 2) {
                            words[i >>> 3] |= parseInt(hexStr.substr(i, 2), 16) << (24 - (i % 8) * 4);
                        }

                        return new WordArray.init(words, hexStrLength / 2);
                    }
                };

                /**
                 * Latin1 encoding strategy.
                 */
                var Latin1 = C_enc.Latin1 = {
                    /**
                     * Converts a word array to a Latin1 string.
                     *
                     * @param {WordArray} wordArray The word array.
                     *
                     * @return {string} The Latin1 string.
                     *
                     * @static
                     *
                     * @example
                     *
                     *     var latin1String = CryptoJS.enc.Latin1.stringify(wordArray);
                     */
                    stringify: function (wordArray) {
                        // Shortcuts
                        var words = wordArray.words;
                        var sigBytes = wordArray.sigBytes;

                        // Convert
                        var latin1Chars = [];
                        for (var i = 0; i < sigBytes; i++) {
                            var bite = (words[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff;
                            latin1Chars.push(String.fromCharCode(bite));
                        }

                        return latin1Chars.join('');
                    },

                    /**
                     * Converts a Latin1 string to a word array.
                     *
                     * @param {string} latin1Str The Latin1 string.
                     *
                     * @return {WordArray} The word array.
                     *
                     * @static
                     *
                     * @example
                     *
                     *     var wordArray = CryptoJS.enc.Latin1.parse(latin1String);
                     */
                    parse: function (latin1Str) {
                        // Shortcut
                        var latin1StrLength = latin1Str.length;

                        // Convert
                        var words = [];
                        for (var i = 0; i < latin1StrLength; i++) {
                            words[i >>> 2] |= (latin1Str.charCodeAt(i) & 0xff) << (24 - (i % 4) * 8);
                        }

                        return new WordArray.init(words, latin1StrLength);
                    }
                };

                /**
                 * UTF-8 encoding strategy.
                 */
                var Utf8 = C_enc.Utf8 = {
                    /**
                     * Converts a word array to a UTF-8 string.
                     *
                     * @param {WordArray} wordArray The word array.
                     *
                     * @return {string} The UTF-8 string.
                     *
                     * @static
                     *
                     * @example
                     *
                     *     var utf8String = CryptoJS.enc.Utf8.stringify(wordArray);
                     */
                    stringify: function (wordArray) {
                        try {
                            return decodeURIComponent(escape(Latin1.stringify(wordArray)));
                        } catch (e) {
                            throw new Error('Malformed UTF-8 data');
                        }
                    },

                    /**
                     * Converts a UTF-8 string to a word array.
                     *
                     * @param {string} utf8Str The UTF-8 string.
                     *
                     * @return {WordArray} The word array.
                     *
                     * @static
                     *
                     * @example
                     *
                     *     var wordArray = CryptoJS.enc.Utf8.parse(utf8String);
                     */
                    parse: function (utf8Str) {
                        return Latin1.parse(unescape(encodeURIComponent(utf8Str)));
                    }
                };

                /**
                 * Abstract buffered block algorithm template.
                 *
                 * The property blockSize must be implemented in a concrete subtype.
                 *
                 * @property {number} _minBufferSize The number of blocks that should be kept unprocessed in the buffer. Default: 0
                 */
                var BufferedBlockAlgorithm = C_lib.BufferedBlockAlgorithm = Base.extend({
                    /**
                     * Resets this block algorithm's data buffer to its initial state.
                     *
                     * @example
                     *
                     *     bufferedBlockAlgorithm.reset();
                     */
                    reset: function () {
                        // Initial values
                        this._data = new WordArray.init();
                        this._nDataBytes = 0;
                    },

                    /**
                     * Adds new data to this block algorithm's buffer.
                     *
                     * @param {WordArray|string} data The data to append. Strings are converted to a WordArray using UTF-8.
                     *
                     * @example
                     *
                     *     bufferedBlockAlgorithm._append('data');
                     *     bufferedBlockAlgorithm._append(wordArray);
                     */
                    _append: function (data) {
                        // Convert string to WordArray, else assume WordArray already
                        if (typeof data == 'string') {
                            data = Utf8.parse(data);
                        }

                        // Append
                        this._data.concat(data);
                        this._nDataBytes += data.sigBytes;
                    },

                    /**
                     * Processes available data blocks.
                     *
                     * This method invokes _doProcessBlock(offset), which must be implemented by a concrete subtype.
                     *
                     * @param {boolean} doFlush Whether all blocks and partial blocks should be processed.
                     *
                     * @return {WordArray} The processed data.
                     *
                     * @example
                     *
                     *     var processedData = bufferedBlockAlgorithm._process();
                     *     var processedData = bufferedBlockAlgorithm._process(!!'flush');
                     */
                    _process: function (doFlush) {
                        // Shortcuts
                        var data = this._data;
                        var dataWords = data.words;
                        var dataSigBytes = data.sigBytes;
                        var blockSize = this.blockSize;
                        var blockSizeBytes = blockSize * 4;

                        // Count blocks ready
                        var nBlocksReady = dataSigBytes / blockSizeBytes;
                        if (doFlush) {
                            // Round up to include partial blocks
                            nBlocksReady = Math.ceil(nBlocksReady);
                        } else {
                            // Round down to include only full blocks,
                            // less the number of blocks that must remain in the buffer
                            nBlocksReady = Math.max((nBlocksReady | 0) - this._minBufferSize, 0);
                        }

                        // Count words ready
                        var nWordsReady = nBlocksReady * blockSize;

                        // Count bytes ready
                        var nBytesReady = Math.min(nWordsReady * 4, dataSigBytes);

                        // Process blocks
                        if (nWordsReady) {
                            for (var offset = 0; offset < nWordsReady; offset += blockSize) {
                                // Perform concrete-algorithm logic
                                this._doProcessBlock(dataWords, offset);
                            }

                            // Remove processed words
                            var processedWords = dataWords.splice(0, nWordsReady);
                            data.sigBytes -= nBytesReady;
                        }

                        // Return processed words
                        return new WordArray.init(processedWords, nBytesReady);
                    },

                    /**
                     * Creates a copy of this object.
                     *
                     * @return {Object} The clone.
                     *
                     * @example
                     *
                     *     var clone = bufferedBlockAlgorithm.clone();
                     */
                    clone: function () {
                        var clone = Base.clone.call(this);
                        clone._data = this._data.clone();

                        return clone;
                    },

                    _minBufferSize: 0
                });

                /**
                 * Abstract hasher template.
                 *
                 * @property {number} blockSize The number of 32-bit words this hasher operates on. Default: 16 (512 bits)
                 */
                var Hasher = C_lib.Hasher = BufferedBlockAlgorithm.extend({
                    /**
                     * Configuration options.
                     */
                    cfg: Base.extend(),

                    /**
                     * Initializes a newly created hasher.
                     *
                     * @param {Object} cfg (Optional) The configuration options to use for this hash computation.
                     *
                     * @example
                     *
                     *     var hasher = CryptoJS.algo.SHA256.create();
                     */
                    init: function (cfg) {
                        // Apply config defaults
                        this.cfg = this.cfg.extend(cfg);

                        // Set initial values
                        this.reset();
                    },

                    /**
                     * Resets this hasher to its initial state.
                     *
                     * @example
                     *
                     *     hasher.reset();
                     */
                    reset: function () {
                        // Reset data buffer
                        BufferedBlockAlgorithm.reset.call(this);

                        // Perform concrete-hasher logic
                        this._doReset();
                    },

                    /**
                     * Updates this hasher with a message.
                     *
                     * @param {WordArray|string} messageUpdate The message to append.
                     *
                     * @return {Hasher} This hasher.
                     *
                     * @example
                     *
                     *     hasher.update('message');
                     *     hasher.update(wordArray);
                     */
                    update: function (messageUpdate) {
                        // Append
                        this._append(messageUpdate);

                        // Update the hash
                        this._process();

                        // Chainable
                        return this;
                    },

                    /**
                     * Finalizes the hash computation.
                     * Note that the finalize operation is effectively a destructive, read-once operation.
                     *
                     * @param {WordArray|string} messageUpdate (Optional) A final message update.
                     *
                     * @return {WordArray} The hash.
                     *
                     * @example
                     *
                     *     var hash = hasher.finalize();
                     *     var hash = hasher.finalize('message');
                     *     var hash = hasher.finalize(wordArray);
                     */
                    finalize: function (messageUpdate) {
                        // Final message update
                        if (messageUpdate) {
                            this._append(messageUpdate);
                        }

                        // Perform concrete-hasher logic
                        var hash = this._doFinalize();

                        return hash;
                    },

                    blockSize: 512/32,

                    /**
                     * Creates a shortcut function to a hasher's object interface.
                     *
                     * @param {Hasher} hasher The hasher to create a helper for.
                     *
                     * @return {Function} The shortcut function.
                     *
                     * @static
                     *
                     * @example
                     *
                     *     var SHA256 = CryptoJS.lib.Hasher._createHelper(CryptoJS.algo.SHA256);
                     */
                    _createHelper: function (hasher) {
                        return function (message, cfg) {
                            return new hasher.init(cfg).finalize(message);
                        };
                    },

                    /**
                     * Creates a shortcut function to the HMAC's object interface.
                     *
                     * @param {Hasher} hasher The hasher to use in this HMAC helper.
                     *
                     * @return {Function} The shortcut function.
                     *
                     * @static
                     *
                     * @example
                     *
                     *     var HmacSHA256 = CryptoJS.lib.Hasher._createHmacHelper(CryptoJS.algo.SHA256);
                     */
                    _createHmacHelper: function (hasher) {
                        return function (message, key) {
                            return new C_algo.HMAC.init(hasher, key).finalize(message);
                        };
                    }
                });

                /**
                 * Algorithm namespace.
                 */
                var C_algo = C.algo = {};

                return C;
            }(Math));


            return CryptoJS;

        }));
    });

    var sha256 = createCommonjsModule(function (module, exports) {
        ;(function (root, factory) {
            if ('object' === "object") {
                // CommonJS
                module.exports = exports = factory(core);
            }
            else if (typeof undefined === "function" && undefined.amd) {
                // AMD
                undefined(["./core"], factory);
            }
            else {
                // Global (browser)
                factory(root.CryptoJS);
            }
        }(commonjsGlobal, function (CryptoJS) {

            (function (Math) {
                // Shortcuts
                var C = CryptoJS;
                var C_lib = C.lib;
                var WordArray = C_lib.WordArray;
                var Hasher = C_lib.Hasher;
                var C_algo = C.algo;

                // Initialization and round constants tables
                var H = [];
                var K = [];

                // Compute constants
                (function () {
                    function isPrime(n) {
                        var sqrtN = Math.sqrt(n);
                        for (var factor = 2; factor <= sqrtN; factor++) {
                            if (!(n % factor)) {
                                return false;
                            }
                        }

                        return true;
                    }

                    function getFractionalBits(n) {
                        return ((n - (n | 0)) * 0x100000000) | 0;
                    }

                    var n = 2;
                    var nPrime = 0;
                    while (nPrime < 64) {
                        if (isPrime(n)) {
                            if (nPrime < 8) {
                                H[nPrime] = getFractionalBits(Math.pow(n, 1 / 2));
                            }
                            K[nPrime] = getFractionalBits(Math.pow(n, 1 / 3));

                            nPrime++;
                        }

                        n++;
                    }
                }());

                // Reusable object
                var W = [];

                /**
                 * SHA-256 hash algorithm.
                 */
                var SHA256 = C_algo.SHA256 = Hasher.extend({
                    _doReset: function () {
                        this._hash = new WordArray.init(H.slice(0));
                    },

                    _doProcessBlock: function (M, offset) {
                        // Shortcut
                        var H = this._hash.words;

                        // Working variables
                        var a = H[0];
                        var b = H[1];
                        var c = H[2];
                        var d = H[3];
                        var e = H[4];
                        var f = H[5];
                        var g = H[6];
                        var h = H[7];

                        // Computation
                        for (var i = 0; i < 64; i++) {
                            if (i < 16) {
                                W[i] = M[offset + i] | 0;
                            } else {
                                var gamma0x = W[i - 15];
                                var gamma0  = ((gamma0x << 25) | (gamma0x >>> 7))  ^
                                    ((gamma0x << 14) | (gamma0x >>> 18)) ^
                                    (gamma0x >>> 3);

                                var gamma1x = W[i - 2];
                                var gamma1  = ((gamma1x << 15) | (gamma1x >>> 17)) ^
                                    ((gamma1x << 13) | (gamma1x >>> 19)) ^
                                    (gamma1x >>> 10);

                                W[i] = gamma0 + W[i - 7] + gamma1 + W[i - 16];
                            }

                            var ch  = (e & f) ^ (~e & g);
                            var maj = (a & b) ^ (a & c) ^ (b & c);

                            var sigma0 = ((a << 30) | (a >>> 2)) ^ ((a << 19) | (a >>> 13)) ^ ((a << 10) | (a >>> 22));
                            var sigma1 = ((e << 26) | (e >>> 6)) ^ ((e << 21) | (e >>> 11)) ^ ((e << 7)  | (e >>> 25));

                            var t1 = h + sigma1 + ch + K[i] + W[i];
                            var t2 = sigma0 + maj;

                            h = g;
                            g = f;
                            f = e;
                            e = (d + t1) | 0;
                            d = c;
                            c = b;
                            b = a;
                            a = (t1 + t2) | 0;
                        }

                        // Intermediate hash value
                        H[0] = (H[0] + a) | 0;
                        H[1] = (H[1] + b) | 0;
                        H[2] = (H[2] + c) | 0;
                        H[3] = (H[3] + d) | 0;
                        H[4] = (H[4] + e) | 0;
                        H[5] = (H[5] + f) | 0;
                        H[6] = (H[6] + g) | 0;
                        H[7] = (H[7] + h) | 0;
                    },

                    _doFinalize: function () {
                        // Shortcuts
                        var data = this._data;
                        var dataWords = data.words;

                        var nBitsTotal = this._nDataBytes * 8;
                        var nBitsLeft = data.sigBytes * 8;

                        // Add padding
                        dataWords[nBitsLeft >>> 5] |= 0x80 << (24 - nBitsLeft % 32);
                        dataWords[(((nBitsLeft + 64) >>> 9) << 4) + 14] = Math.floor(nBitsTotal / 0x100000000);
                        dataWords[(((nBitsLeft + 64) >>> 9) << 4) + 15] = nBitsTotal;
                        data.sigBytes = dataWords.length * 4;

                        // Hash final blocks
                        this._process();

                        // Return final computed hash
                        return this._hash;
                    },

                    clone: function () {
                        var clone = Hasher.clone.call(this);
                        clone._hash = this._hash.clone();

                        return clone;
                    }
                });

                /**
                 * Shortcut function to the hasher's object interface.
                 *
                 * @param {WordArray|string} message The message to hash.
                 *
                 * @return {WordArray} The hash.
                 *
                 * @static
                 *
                 * @example
                 *
                 *     var hash = CryptoJS.SHA256('message');
                 *     var hash = CryptoJS.SHA256(wordArray);
                 */
                C.SHA256 = Hasher._createHelper(SHA256);

                /**
                 * Shortcut function to the HMAC's object interface.
                 *
                 * @param {WordArray|string} message The message to hash.
                 * @param {WordArray|string} key The secret key.
                 *
                 * @return {WordArray} The HMAC.
                 *
                 * @static
                 *
                 * @example
                 *
                 *     var hmac = CryptoJS.HmacSHA256(message, key);
                 */
                C.HmacSHA256 = Hasher._createHmacHelper(SHA256);
            }(Math));


            return CryptoJS.SHA256;

        }));
    });

    var encBase64 = createCommonjsModule(function (module, exports) {
        ;(function (root, factory) {
            if ('object' === "object") {
                // CommonJS
                module.exports = exports = factory(core);
            }
            else if (typeof undefined === "function" && undefined.amd) {
                // AMD
                undefined(["./core"], factory);
            }
            else {
                // Global (browser)
                factory(root.CryptoJS);
            }
        }(commonjsGlobal, function (CryptoJS) {

            (function () {
                // Shortcuts
                var C = CryptoJS;
                var C_lib = C.lib;
                var WordArray = C_lib.WordArray;
                var C_enc = C.enc;

                /**
                 * Base64 encoding strategy.
                 */
                var Base64 = C_enc.Base64 = {
                    /**
                     * Converts a word array to a Base64 string.
                     *
                     * @param {WordArray} wordArray The word array.
                     *
                     * @return {string} The Base64 string.
                     *
                     * @static
                     *
                     * @example
                     *
                     *     var base64String = CryptoJS.enc.Base64.stringify(wordArray);
                     */
                    stringify: function (wordArray) {
                        // Shortcuts
                        var words = wordArray.words;
                        var sigBytes = wordArray.sigBytes;
                        var map = this._map;

                        // Clamp excess bits
                        wordArray.clamp();

                        // Convert
                        var base64Chars = [];
                        for (var i = 0; i < sigBytes; i += 3) {
                            var byte1 = (words[i >>> 2]       >>> (24 - (i % 4) * 8))       & 0xff;
                            var byte2 = (words[(i + 1) >>> 2] >>> (24 - ((i + 1) % 4) * 8)) & 0xff;
                            var byte3 = (words[(i + 2) >>> 2] >>> (24 - ((i + 2) % 4) * 8)) & 0xff;

                            var triplet = (byte1 << 16) | (byte2 << 8) | byte3;

                            for (var j = 0; (j < 4) && (i + j * 0.75 < sigBytes); j++) {
                                base64Chars.push(map.charAt((triplet >>> (6 * (3 - j))) & 0x3f));
                            }
                        }

                        // Add padding
                        var paddingChar = map.charAt(64);
                        if (paddingChar) {
                            while (base64Chars.length % 4) {
                                base64Chars.push(paddingChar);
                            }
                        }

                        return base64Chars.join('');
                    },

                    /**
                     * Converts a Base64 string to a word array.
                     *
                     * @param {string} base64Str The Base64 string.
                     *
                     * @return {WordArray} The word array.
                     *
                     * @static
                     *
                     * @example
                     *
                     *     var wordArray = CryptoJS.enc.Base64.parse(base64String);
                     */
                    parse: function (base64Str) {
                        // Shortcuts
                        var base64StrLength = base64Str.length;
                        var map = this._map;
                        var reverseMap = this._reverseMap;

                        if (!reverseMap) {
                            reverseMap = this._reverseMap = [];
                            for (var j = 0; j < map.length; j++) {
                                reverseMap[map.charCodeAt(j)] = j;
                            }
                        }

                        // Ignore padding
                        var paddingChar = map.charAt(64);
                        if (paddingChar) {
                            var paddingIndex = base64Str.indexOf(paddingChar);
                            if (paddingIndex !== -1) {
                                base64StrLength = paddingIndex;
                            }
                        }

                        // Convert
                        return parseLoop(base64Str, base64StrLength, reverseMap);

                    },

                    _map: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='
                };

                function parseLoop(base64Str, base64StrLength, reverseMap) {
                    var words = [];
                    var nBytes = 0;
                    for (var i = 0; i < base64StrLength; i++) {
                        if (i % 4) {
                            var bits1 = reverseMap[base64Str.charCodeAt(i - 1)] << ((i % 4) * 2);
                            var bits2 = reverseMap[base64Str.charCodeAt(i)] >>> (6 - (i % 4) * 2);
                            words[nBytes >>> 2] |= (bits1 | bits2) << (24 - (nBytes % 4) * 8);
                            nBytes++;
                        }
                    }
                    return WordArray.create(words, nBytes);
                }
            }());


            return CryptoJS.enc.Base64;

        }));
    });

    var _nodeResolve_empty = {};

    var _nodeResolve_empty$1 = /*#__PURE__*/Object.freeze({
        __proto__: null,
        'default': _nodeResolve_empty
    });

    var require$$0 = getCjsExportFromNamespace(_nodeResolve_empty$1);

    var secureRandom = createCommonjsModule(function (module) {
        !function(globals){
            'use strict';

            //*** UMD BEGIN
            if (typeof undefined !== 'undefined' && undefined.amd) { //require.js / AMD
                undefined([], function() {
                    return secureRandom
                });
            } else if ('object' !== 'undefined' && module.exports) { //CommonJS
                module.exports = secureRandom;
            } else { //script / browser
                globals.secureRandom = secureRandom;
            }
            //*** UMD END

            //options.type is the only valid option
            function secureRandom(count, options) {
                options = options || {type: 'Array'};
                //we check for process.pid to prevent browserify from tricking us
                if (
                    typeof process != 'undefined'
                    && typeof process.pid == 'number'
                    && process.versions
                    && process.versions.node
                ) {
                    return nodeRandom(count, options)
                } else {
                    var crypto = window.crypto || window.msCrypto;
                    if (!crypto) throw new Error("Your browser does not support window.crypto.")
                    return browserRandom(count, options)
                }
            }

            function nodeRandom(count, options) {
                var crypto = require$$0;
                var buf = crypto.randomBytes(count);

                switch (options.type) {
                    case 'Array':
                        return [].slice.call(buf)
                    case 'Buffer':
                        return buf
                    case 'Uint8Array':
                        var arr = new Uint8Array(count);
                        for (var i = 0; i < count; ++i) { arr[i] = buf.readUInt8(i); }
                        return arr
                    default:
                        throw new Error(options.type + " is unsupported.")
                }
            }

            function browserRandom(count, options) {
                var nativeArr = new Uint8Array(count);
                var crypto = window.crypto || window.msCrypto;
                crypto.getRandomValues(nativeArr);

                switch (options.type) {
                    case 'Array':
                        return [].slice.call(nativeArr)
                    case 'Buffer':
                        try { var b = new Buffer(1); } catch(e) { throw new Error('Buffer not supported in this environment. Use Node.js or Browserify for browser support.')}
                        return new Buffer(nativeArr)
                    case 'Uint8Array':
                        return nativeArr
                    default:
                        throw new Error(options.type + " is unsupported.")
                }
            }

            secureRandom.randomArray = function(byteCount) {
                return secureRandom(byteCount, {type: 'Array'})
            };

            secureRandom.randomUint8Array = function(byteCount) {
                return secureRandom(byteCount, {type: 'Uint8Array'})
            };

            secureRandom.randomBuffer = function(byteCount) {
                return secureRandom(byteCount, {type: 'Buffer'})
            };


        }(commonjsGlobal);
    });

    var lib = createCommonjsModule(function (module, exports) {
        "use strict";
        exports.__esModule = true;



        var mask = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~";
        function random(size) {
            var value = "";
            var bytes = secureRandom(size);
            var scale = 256 / mask.length; // 256 = 0 to 0xFF (randomBytes)
            for (var i = 0; i < size; i++) {
                value += mask.charAt(Math.floor(bytes[i] / scale));
            }
            return value;
        }
        function hash(str) {
            return encBase64.stringify(sha256(str));
        }
        function base64url(str) {
            return str
                .replace(/=/g, "")
                .replace(/\+/g, "-")
                .replace(/\//g, "_");
        }
        function createVerifier(length) {
            if (length === void 0) { length = 128; }
            if (length < 43 || length > 128) {
                throw new Error("expected length " + length + " between 43 and 128");
            }
            return random(length);
        }
        exports.createVerifier = createVerifier;
        function createChallenge(verifier) {
            return base64url(hash(verifier));
        }
        exports.createChallenge = createChallenge;
        function create(length) {
            if (length === void 0) { length = 128; }
            var verifier = createVerifier(length);
            var challenge = createChallenge(verifier);
            return {
                codeVerifier: verifier,
                codeChallenge: challenge
            };
        }
        exports.create = create;
    });

    var pkce = unwrapExports(lib);
    var lib_1 = lib.createVerifier;
    var lib_2 = lib.createChallenge;
    var lib_3 = lib.create;

    var prism = createCommonjsModule(function (module) {
        /* **********************************************
         Begin prism-core.js
    ********************************************** */

        var _self = (typeof window !== 'undefined')
            ? window   // if in browser
            : (
                (typeof WorkerGlobalScope !== 'undefined' && self instanceof WorkerGlobalScope)
                    ? self // if in worker
                    : {}   // if in node js
            );

        /**
         * Prism: Lightweight, robust, elegant syntax highlighting
         * MIT license http://www.opensource.org/licenses/mit-license.php/
         * @author Lea Verou http://lea.verou.me
         */

        var Prism = (function (_self){

            // Private helper vars
            var lang = /\blang(?:uage)?-([\w-]+)\b/i;
            var uniqueId = 0;

            var _ = {
                manual: _self.Prism && _self.Prism.manual,
                disableWorkerMessageHandler: _self.Prism && _self.Prism.disableWorkerMessageHandler,
                util: {
                    encode: function (tokens) {
                        if (tokens instanceof Token) {
                            return new Token(tokens.type, _.util.encode(tokens.content), tokens.alias);
                        } else if (Array.isArray(tokens)) {
                            return tokens.map(_.util.encode);
                        } else {
                            return tokens.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/\u00a0/g, ' ');
                        }
                    },

                    type: function (o) {
                        return Object.prototype.toString.call(o).slice(8, -1);
                    },

                    objId: function (obj) {
                        if (!obj['__id']) {
                            Object.defineProperty(obj, '__id', { value: ++uniqueId });
                        }
                        return obj['__id'];
                    },

                    // Deep clone a language definition (e.g. to extend it)
                    clone: function deepClone(o, visited) {
                        var clone, id, type = _.util.type(o);
                        visited = visited || {};

                        switch (type) {
                            case 'Object':
                                id = _.util.objId(o);
                                if (visited[id]) {
                                    return visited[id];
                                }
                                clone = {};
                                visited[id] = clone;

                                for (var key in o) {
                                    if (o.hasOwnProperty(key)) {
                                        clone[key] = deepClone(o[key], visited);
                                    }
                                }

                                return clone;

                            case 'Array':
                                id = _.util.objId(o);
                                if (visited[id]) {
                                    return visited[id];
                                }
                                clone = [];
                                visited[id] = clone;

                                o.forEach(function (v, i) {
                                    clone[i] = deepClone(v, visited);
                                });

                                return clone;

                            default:
                                return o;
                        }
                    }
                },

                languages: {
                    extend: function (id, redef) {
                        var lang = _.util.clone(_.languages[id]);

                        for (var key in redef) {
                            lang[key] = redef[key];
                        }

                        return lang;
                    },

                    /**
                     * Insert a token before another token in a language literal
                     * As this needs to recreate the object (we cannot actually insert before keys in object literals),
                     * we cannot just provide an object, we need an object and a key.
                     * @param inside The key (or language id) of the parent
                     * @param before The key to insert before.
                     * @param insert Object with the key/value pairs to insert
                     * @param root The object that contains `inside`. If equal to Prism.languages, it can be omitted.
                     */
                    insertBefore: function (inside, before, insert, root) {
                        root = root || _.languages;
                        var grammar = root[inside];
                        var ret = {};

                        for (var token in grammar) {
                            if (grammar.hasOwnProperty(token)) {

                                if (token == before) {
                                    for (var newToken in insert) {
                                        if (insert.hasOwnProperty(newToken)) {
                                            ret[newToken] = insert[newToken];
                                        }
                                    }
                                }

                                // Do not insert token which also occur in insert. See #1525
                                if (!insert.hasOwnProperty(token)) {
                                    ret[token] = grammar[token];
                                }
                            }
                        }

                        var old = root[inside];
                        root[inside] = ret;

                        // Update references in other language definitions
                        _.languages.DFS(_.languages, function(key, value) {
                            if (value === old && key != inside) {
                                this[key] = ret;
                            }
                        });

                        return ret;
                    },

                    // Traverse a language definition with Depth First Search
                    DFS: function DFS(o, callback, type, visited) {
                        visited = visited || {};

                        var objId = _.util.objId;

                        for (var i in o) {
                            if (o.hasOwnProperty(i)) {
                                callback.call(o, i, o[i], type || i);

                                var property = o[i],
                                    propertyType = _.util.type(property);

                                if (propertyType === 'Object' && !visited[objId(property)]) {
                                    visited[objId(property)] = true;
                                    DFS(property, callback, null, visited);
                                }
                                else if (propertyType === 'Array' && !visited[objId(property)]) {
                                    visited[objId(property)] = true;
                                    DFS(property, callback, i, visited);
                                }
                            }
                        }
                    }
                },
                plugins: {},

                highlightAll: function(async, callback) {
                    _.highlightAllUnder(document, async, callback);
                },

                highlightAllUnder: function(container, async, callback) {
                    var env = {
                        callback: callback,
                        selector: 'code[class*="language-"], [class*="language-"] code, code[class*="lang-"], [class*="lang-"] code'
                    };

                    _.hooks.run('before-highlightall', env);

                    var elements = container.querySelectorAll(env.selector);

                    for (var i=0, element; element = elements[i++];) {
                        _.highlightElement(element, async === true, env.callback);
                    }
                },

                highlightElement: function(element, async, callback) {
                    // Find language
                    var language = 'none', grammar, parent = element;

                    while (parent && !lang.test(parent.className)) {
                        parent = parent.parentNode;
                    }

                    if (parent) {
                        language = (parent.className.match(lang) || [,'none'])[1].toLowerCase();
                        grammar = _.languages[language];
                    }

                    // Set language on the element, if not present
                    element.className = element.className.replace(lang, '').replace(/\s+/g, ' ') + ' language-' + language;

                    if (element.parentNode) {
                        // Set language on the parent, for styling
                        parent = element.parentNode;

                        if (/pre/i.test(parent.nodeName)) {
                            parent.className = parent.className.replace(lang, '').replace(/\s+/g, ' ') + ' language-' + language;
                        }
                    }

                    var code = element.textContent;

                    var env = {
                        element: element,
                        language: language,
                        grammar: grammar,
                        code: code
                    };

                    var insertHighlightedCode = function (highlightedCode) {
                        env.highlightedCode = highlightedCode;

                        _.hooks.run('before-insert', env);

                        env.element.innerHTML = env.highlightedCode;

                        _.hooks.run('after-highlight', env);
                        _.hooks.run('complete', env);
                        callback && callback.call(env.element);
                    };

                    _.hooks.run('before-sanity-check', env);

                    if (!env.code) {
                        _.hooks.run('complete', env);
                        return;
                    }

                    _.hooks.run('before-highlight', env);

                    if (!env.grammar) {
                        insertHighlightedCode(_.util.encode(env.code));
                        return;
                    }

                    if (async && _self.Worker) {
                        var worker = new Worker(_.filename);

                        worker.onmessage = function(evt) {
                            insertHighlightedCode(evt.data);
                        };

                        worker.postMessage(JSON.stringify({
                            language: env.language,
                            code: env.code,
                            immediateClose: true
                        }));
                    }
                    else {
                        insertHighlightedCode(_.highlight(env.code, env.grammar, env.language));
                    }
                },

                highlight: function (text, grammar, language) {
                    var env = {
                        code: text,
                        grammar: grammar,
                        language: language
                    };
                    _.hooks.run('before-tokenize', env);
                    env.tokens = _.tokenize(env.code, env.grammar);
                    _.hooks.run('after-tokenize', env);
                    return Token.stringify(_.util.encode(env.tokens), env.language);
                },

                matchGrammar: function (text, strarr, grammar, index, startPos, oneshot, target) {
                    for (var token in grammar) {
                        if(!grammar.hasOwnProperty(token) || !grammar[token]) {
                            continue;
                        }

                        if (token == target) {
                            return;
                        }

                        var patterns = grammar[token];
                        patterns = (_.util.type(patterns) === "Array") ? patterns : [patterns];

                        for (var j = 0; j < patterns.length; ++j) {
                            var pattern = patterns[j],
                                inside = pattern.inside,
                                lookbehind = !!pattern.lookbehind,
                                greedy = !!pattern.greedy,
                                lookbehindLength = 0,
                                alias = pattern.alias;

                            if (greedy && !pattern.pattern.global) {
                                // Without the global flag, lastIndex won't work
                                var flags = pattern.pattern.toString().match(/[imuy]*$/)[0];
                                pattern.pattern = RegExp(pattern.pattern.source, flags + "g");
                            }

                            pattern = pattern.pattern || pattern;

                            // Don’t cache length as it changes during the loop
                            for (var i = index, pos = startPos; i < strarr.length; pos += strarr[i].length, ++i) {

                                var str = strarr[i];

                                if (strarr.length > text.length) {
                                    // Something went terribly wrong, ABORT, ABORT!
                                    return;
                                }

                                if (str instanceof Token) {
                                    continue;
                                }

                                if (greedy && i != strarr.length - 1) {
                                    pattern.lastIndex = pos;
                                    var match = pattern.exec(text);
                                    if (!match) {
                                        break;
                                    }

                                    var from = match.index + (lookbehind ? match[1].length : 0),
                                        to = match.index + match[0].length,
                                        k = i,
                                        p = pos;

                                    for (var len = strarr.length; k < len && (p < to || (!strarr[k].type && !strarr[k - 1].greedy)); ++k) {
                                        p += strarr[k].length;
                                        // Move the index i to the element in strarr that is closest to from
                                        if (from >= p) {
                                            ++i;
                                            pos = p;
                                        }
                                    }

                                    // If strarr[i] is a Token, then the match starts inside another Token, which is invalid
                                    if (strarr[i] instanceof Token) {
                                        continue;
                                    }

                                    // Number of tokens to delete and replace with the new match
                                    delNum = k - i;
                                    str = text.slice(pos, p);
                                    match.index -= pos;
                                } else {
                                    pattern.lastIndex = 0;

                                    var match = pattern.exec(str),
                                        delNum = 1;
                                }

                                if (!match) {
                                    if (oneshot) {
                                        break;
                                    }

                                    continue;
                                }

                                if(lookbehind) {
                                    lookbehindLength = match[1] ? match[1].length : 0;
                                }

                                var from = match.index + lookbehindLength,
                                    match = match[0].slice(lookbehindLength),
                                    to = from + match.length,
                                    before = str.slice(0, from),
                                    after = str.slice(to);

                                var args = [i, delNum];

                                if (before) {
                                    ++i;
                                    pos += before.length;
                                    args.push(before);
                                }

                                var wrapped = new Token(token, inside? _.tokenize(match, inside) : match, alias, match, greedy);

                                args.push(wrapped);

                                if (after) {
                                    args.push(after);
                                }

                                Array.prototype.splice.apply(strarr, args);

                                if (delNum != 1)
                                    _.matchGrammar(text, strarr, grammar, i, pos, true, token);

                                if (oneshot)
                                    break;
                            }
                        }
                    }
                },

                tokenize: function(text, grammar) {
                    var strarr = [text];

                    var rest = grammar.rest;

                    if (rest) {
                        for (var token in rest) {
                            grammar[token] = rest[token];
                        }

                        delete grammar.rest;
                    }

                    _.matchGrammar(text, strarr, grammar, 0, 0, false);

                    return strarr;
                },

                hooks: {
                    all: {},

                    add: function (name, callback) {
                        var hooks = _.hooks.all;

                        hooks[name] = hooks[name] || [];

                        hooks[name].push(callback);
                    },

                    run: function (name, env) {
                        var callbacks = _.hooks.all[name];

                        if (!callbacks || !callbacks.length) {
                            return;
                        }

                        for (var i=0, callback; callback = callbacks[i++];) {
                            callback(env);
                        }
                    }
                },

                Token: Token
            };

            _self.Prism = _;

            function Token(type, content, alias, matchedStr, greedy) {
                this.type = type;
                this.content = content;
                this.alias = alias;
                // Copy of the full string this token was created from
                this.length = (matchedStr || "").length|0;
                this.greedy = !!greedy;
            }

            Token.stringify = function(o, language) {
                if (typeof o == 'string') {
                    return o;
                }

                if (Array.isArray(o)) {
                    return o.map(function(element) {
                        return Token.stringify(element, language);
                    }).join('');
                }

                var env = {
                    type: o.type,
                    content: Token.stringify(o.content, language),
                    tag: 'span',
                    classes: ['token', o.type],
                    attributes: {},
                    language: language
                };

                if (o.alias) {
                    var aliases = Array.isArray(o.alias) ? o.alias : [o.alias];
                    Array.prototype.push.apply(env.classes, aliases);
                }

                _.hooks.run('wrap', env);

                var attributes = Object.keys(env.attributes).map(function(name) {
                    return name + '="' + (env.attributes[name] || '').replace(/"/g, '&quot;') + '"';
                }).join(' ');

                return '<' + env.tag + ' class="' + env.classes.join(' ') + '"' + (attributes ? ' ' + attributes : '') + '>' + env.content + '</' + env.tag + '>';
            };

            if (!_self.document) {
                if (!_self.addEventListener) {
                    // in Node.js
                    return _;
                }

                if (!_.disableWorkerMessageHandler) {
                    // In worker
                    _self.addEventListener('message', function (evt) {
                        var message = JSON.parse(evt.data),
                            lang = message.language,
                            code = message.code,
                            immediateClose = message.immediateClose;

                        _self.postMessage(_.highlight(code, _.languages[lang], lang));
                        if (immediateClose) {
                            _self.close();
                        }
                    }, false);
                }

                return _;
            }

            //Get current script and highlight
            var script = document.currentScript || [].slice.call(document.getElementsByTagName("script")).pop();

            if (script) {
                _.filename = script.src;

                if (!_.manual && !script.hasAttribute('data-manual')) {
                    if(document.readyState !== "loading") {
                        if (window.requestAnimationFrame) {
                            window.requestAnimationFrame(_.highlightAll);
                        } else {
                            window.setTimeout(_.highlightAll, 16);
                        }
                    }
                    else {
                        document.addEventListener('DOMContentLoaded', _.highlightAll);
                    }
                }
            }

            return _;

        })(_self);

        if ('object' !== 'undefined' && module.exports) {
            module.exports = Prism;
        }

        // hack for components to work correctly in node.js
        if (typeof commonjsGlobal !== 'undefined') {
            commonjsGlobal.Prism = Prism;
        }


        /* **********************************************
         Begin prism-markup.js
    ********************************************** */

        Prism.languages.markup = {
            'comment': /<!--[\s\S]*?-->/,
        'prolog': /<\?[\s\S]+?\?>/,
            'doctype': /<!DOCTYPE[\s\S]+?>/i,
            'cdata': /<!\[CDATA\[[\s\S]*?]]>/i,
            'tag': {
            pattern: /<\/?(?!\d)[^\s>\/=$<%]+(?:\s(?:\s*[^\s>\/=]+(?:\s*=\s*(?:"[^"]*"|'[^']*'|[^\s'">=]+(?=[\s>]))|(?=[\s/>])))+)?\s*\/?>/i,
                greedy: true,
                inside: {
                'tag': {
                    pattern: /^<\/?[^\s>\/]+/i,
                        inside: {
                        'punctuation': /^<\/?/,
                            'namespace': /^[^\s>\/:]+:/
                    }
                },
                'attr-value': {
                    pattern: /=\s*(?:"[^"]*"|'[^']*'|[^\s'">=]+)/i,
                        inside: {
                        'punctuation': [
                            /^=/,
                            {
                                pattern: /^(\s*)["']|["']$/,
                                lookbehind: true
                            }
                        ]
                    }
                },
                'punctuation': /\/?>/,
                    'attr-name': {
                    pattern: /[^\s>\/]+/,
                        inside: {
                        'namespace': /^[^\s>\/:]+:/
                    }
                }

            }
        },
        'entity': /&#?[\da-z]{1,8};/i
    };

        Prism.languages.markup['tag'].inside['attr-value'].inside['entity'] =
            Prism.languages.markup['entity'];

        // Plugin to make entity title show the real entity, idea by Roman Komarov
        Prism.hooks.add('wrap', function(env) {

            if (env.type === 'entity') {
                env.attributes['title'] = env.content.replace(/&amp;/, '&');
            }
        });

        Object.defineProperty(Prism.languages.markup.tag, 'addInlined', {
            /**
             * Adds an inlined language to markup.
             *
             * An example of an inlined language is CSS with `<style>` tags.
             *
             * @param {string} tagName The name of the tag that contains the inlined language. This name will be treated as
             * case insensitive.
             * @param {string} lang The language key.
             * @example
             * addInlined('style', 'css');
             */
            value: function addInlined(tagName, lang) {
                var includedCdataInside = {};
                includedCdataInside['language-' + lang] = {
                    pattern: /(^<!\[CDATA\[)[\s\S]+?(?=\]\]>$)/i,
                    lookbehind: true,
                    inside: Prism.languages[lang]
                };
                includedCdataInside['cdata'] = /^<!\[CDATA\[|\]\]>$/i;

                var inside = {
                    'included-cdata': {
                        pattern: /<!\[CDATA\[[\s\S]*?\]\]>/i,
                        inside: includedCdataInside
                    }
                };
                inside['language-' + lang] = {
                    pattern: /[\s\S]+/,
                    inside: Prism.languages[lang]
                };

                var def = {};
                def[tagName] = {
                    pattern: RegExp(/(<__[\s\S]*?>)(?:<!\[CDATA\[[\s\S]*?\]\]>\s*|[\s\S])*?(?=<\/__>)/.source.replace(/__/g, tagName), 'i'),
                    lookbehind: true,
                    greedy: true,
                    inside: inside
                };

                Prism.languages.insertBefore('markup', 'cdata', def);
            }
        });

        Prism.languages.xml = Prism.languages.extend('markup', {});
        Prism.languages.html = Prism.languages.markup;
        Prism.languages.mathml = Prism.languages.markup;
        Prism.languages.svg = Prism.languages.markup;


        /* **********************************************
         Begin prism-css.js
    ********************************************** */

        (function (Prism) {

            var string = /("|')(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1/;

            Prism.languages.css = {
                'comment': /\/\*[\s\S]*?\*\//,
                'atrule': {
                    pattern: /@[\w-]+[\s\S]*?(?:;|(?=\s*\{))/,
            inside: {
            'rule': /@[\w-]+/
            // See rest below
            }
        },
            'url': {
                pattern: RegExp('url\\((?:' + string.source + '|[^\n\r()]*)\\)', 'i'),
                    inside: {
                    'function': /^url/i,
                        'punctuation': /^\(|\)$/
                }
            },
            'selector': RegExp('[^{}\\s](?:[^{};"\']|' + string.source + ')*?(?=\\s*\\{)'),
    		'string': {
    			pattern: string,
    			greedy: true
    		},
    		'property': /[-_a-z\xA0-\uFFFF][-\w\xA0-\uFFFF]*(?=\s*:)/i,
    		'important': /!important\b/i,
    		'function': /[-a-z0-9]+(?=\()/i,
    		'punctuation': /[(){};:,]/
    	};

    	Prism.languages.css['atrule'].inside.rest = Prism.languages.css;

    	var markup = Prism.languages.markup;
    	if (markup) {
    		markup.tag.addInlined('style', 'css');

    		Prism.languages.insertBefore('inside', 'attr-value', {
    			'style-attr': {
    				pattern: /\s*style=("|')(?:\\[\s\S]|(?!\1)[^\\])*\1/i,
                    inside: {
                    'attr-name': {
                    pattern: /^\s*style/i,
                    inside: markup.tag.inside
                    },
            'punctuation': /^\s*=\s*['"]|['"]\s*$/,
                'attr-value': {
                pattern: /.+/i,
                    inside: Prism.languages.css
            }
        },
            alias: 'language-css'
        }
    }, markup.tag);
    }

    }(Prism));


    /* **********************************************
         Begin prism-clike.js
    ********************************************** */

    Prism.languages.clike = {
        'comment': [
            {
                pattern: /(^|[^\\])\/\*[\s\S]*?(?:\*\/|$)/,
                lookbehind: true
            },
            {
                pattern: /(^|[^\\:])\/\/.*/,
                lookbehind: true,
                greedy: true
            }
        ],
        'string': {
            pattern: /(["'])(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1/,
            greedy: true
        },
        'class-name': {
            pattern: /((?:\b(?:class|interface|extends|implements|trait|instanceof|new)\s+)|(?:catch\s+\())[\w.\\]+/i,
            lookbehind: true,
            inside: {
                punctuation: /[.\\]/
            }
        },
        'keyword': /\b(?:if|else|while|do|for|return|in|instanceof|function|new|try|throw|catch|finally|null|break|continue)\b/,
        'boolean': /\b(?:true|false)\b/,
        'function': /\w+(?=\()/,
        'number': /\b0x[\da-f]+\b|(?:\b\d+\.?\d*|\B\.\d+)(?:e[+-]?\d+)?/i,
        'operator': /--?|\+\+?|!=?=?|<=?|>=?|==?=?|&&?|\|\|?|\?|\*|\/|~|\^|%/,
        'punctuation': /[{}[\];(),.:]/
    };


    /* **********************************************
         Begin prism-javascript.js
    ********************************************** */

    Prism.languages.javascript = Prism.languages.extend('clike', {
        'class-name': [
            Prism.languages.clike['class-name'],
            {
                pattern: /(^|[^$\w\xA0-\uFFFF])[_$A-Z\xA0-\uFFFF][$\w\xA0-\uFFFF]*(?=\.(?:prototype|constructor))/,
                lookbehind: true
            }
        ],
        'keyword': [
            {
                pattern: /((?:^|})\s*)(?:catch|finally)\b/,
                lookbehind: true
            },
            {
                pattern: /(^|[^.])\b(?:as|async(?=\s*(?:function\b|\(|[$\w\xA0-\uFFFF]|$))|await|break|case|class|const|continue|debugger|default|delete|do|else|enum|export|extends|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|set|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)\b/,
                lookbehind: true
            },
        ],
        'number': /\b(?:(?:0[xX](?:[\dA-Fa-f](?:_[\dA-Fa-f])?)+|0[bB](?:[01](?:_[01])?)+|0[oO](?:[0-7](?:_[0-7])?)+)n?|(?:\d(?:_\d)?)+n|NaN|Infinity)\b|(?:\b(?:\d(?:_\d)?)+\.?(?:\d(?:_\d)?)*|\B\.(?:\d(?:_\d)?)+)(?:[Ee][+-]?(?:\d(?:_\d)?)+)?/,
        // Allow for all non-ASCII characters (See http://stackoverflow.com/a/2008444)
        'function': /#?[_$a-zA-Z\xA0-\uFFFF][$\w\xA0-\uFFFF]*(?=\s*(?:\.\s*(?:apply|bind|call)\s*)?\()/,
        'operator': /-[-=]?|\+[+=]?|!=?=?|<<?=?|>>?>?=?|=(?:==?|>)?|&[&=]?|\|[|=]?|\*\*?=?|\/=?|~|\^=?|%=?|\?|\.{3}/
    });

    Prism.languages.javascript['class-name'][0].pattern = /(\b(?:class|interface|extends|implements|instanceof|new)\s+)[\w.\\]+/;

    Prism.languages.insertBefore('javascript', 'keyword', {
        'regex': {
            pattern: /((?:^|[^$\w\xA0-\uFFFF."'\])\s])\s*)\/(\[(?:[^\]\\\r\n]|\\.)*]|\\.|[^/\\\[\r\n])+\/[gimyus]{0,6}(?=\s*($|[\r\n,.;})\]]))/,
            lookbehind: true,
            greedy: true
        },
        // This must be declared before keyword because we use "function" inside the look-forward
        'function-variable': {
            pattern: /#?[_$a-zA-Z\xA0-\uFFFF][$\w\xA0-\uFFFF]*(?=\s*[=:]\s*(?:async\s*)?(?:\bfunction\b|(?:\((?:[^()]|\([^()]*\))*\)|[_$a-zA-Z\xA0-\uFFFF][$\w\xA0-\uFFFF]*)\s*=>))/,
            alias: 'function'
        },
        'parameter': [
            {
                pattern: /(function(?:\s+[_$A-Za-z\xA0-\uFFFF][$\w\xA0-\uFFFF]*)?\s*\(\s*)(?!\s)(?:[^()]|\([^()]*\))+?(?=\s*\))/,
                lookbehind: true,
                inside: Prism.languages.javascript
            },
            {
                pattern: /[_$a-z\xA0-\uFFFF][$\w\xA0-\uFFFF]*(?=\s*=>)/i,
                inside: Prism.languages.javascript
            },
            {
                pattern: /(\(\s*)(?!\s)(?:[^()]|\([^()]*\))+?(?=\s*\)\s*=>)/,
                lookbehind: true,
                inside: Prism.languages.javascript
            },
            {
                pattern: /((?:\b|\s|^)(?!(?:as|async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|set|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)(?![$\w\xA0-\uFFFF]))(?:[_$A-Za-z\xA0-\uFFFF][$\w\xA0-\uFFFF]*\s*)\(\s*)(?!\s)(?:[^()]|\([^()]*\))+?(?=\s*\)\s*\{)/,
    lookbehind: true,
    inside: Prism.languages.javascript
    }
    ],
    'constant': /\b[A-Z](?:[A-Z_]|\dx?)*\b/
    });

    Prism.languages.insertBefore('javascript', 'string', {
        'template-string': {
            pattern: /`(?:\\[\s\S]|\${(?:[^{}]|{(?:[^{}]|{[^}]*})*})+}|(?!\${)[^\\`])*`/,
                    greedy: true,
                    inside: {
                    'template-punctuation': {
                    pattern: /^`|`$/,
                    alias: 'string'
                    },
            'interpolation': {
                pattern: /((?:^|[^\\])(?:\\{2})*)\${(?:[^{}]|{(?:[^{}]|{[^}]*})*})+}/,
                lookbehind: true,
                inside: {
                    'interpolation-punctuation': {
                        pattern: /^\${|}$/,
                        alias: 'punctuation'
                    },
                    rest: Prism.languages.javascript
                }
            },
            'string': /[\s\S]+/
        }
    }
    });

    if (Prism.languages.markup) {
        Prism.languages.markup.tag.addInlined('script', 'javascript');
    }

    Prism.languages.js = Prism.languages.javascript;


    /* **********************************************
         Begin prism-file-highlight.js
    ********************************************** */

    (function () {
        if (typeof self === 'undefined' || !self.Prism || !self.document || !document.querySelector) {
            return;
        }

        /**
         * @param {Element} [container=document]
         */
        self.Prism.fileHighlight = function(container) {
            container = container || document;

            var Extensions = {
                'js': 'javascript',
                'py': 'python',
                'rb': 'ruby',
                'ps1': 'powershell',
                'psm1': 'powershell',
                'sh': 'bash',
                'bat': 'batch',
                'h': 'c',
                'tex': 'latex'
            };

            Array.prototype.slice.call(container.querySelectorAll('pre[data-src]')).forEach(function (pre) {
                // ignore if already loaded
                if (pre.hasAttribute('data-src-loaded')) {
                    return;
                }

                // load current
                var src = pre.getAttribute('data-src');

                var language, parent = pre;
                var lang = /\blang(?:uage)?-([\w-]+)\b/i;
                while (parent && !lang.test(parent.className)) {
                    parent = parent.parentNode;
                }

                if (parent) {
                    language = (pre.className.match(lang) || [, ''])[1];
                }

                if (!language) {
                    var extension = (src.match(/\.(\w+)$/) || [, ''])[1];
                    language = Extensions[extension] || extension;
                }

                var code = document.createElement('code');
                code.className = 'language-' + language;

                pre.textContent = '';

                code.textContent = 'Loading…';

                pre.appendChild(code);

                var xhr = new XMLHttpRequest();

                xhr.open('GET', src, true);

                xhr.onreadystatechange = function () {
                    if (xhr.readyState == 4) {

                        if (xhr.status < 400 && xhr.responseText) {
                            code.textContent = xhr.responseText;

                            Prism.highlightElement(code);
                            // mark as loaded
                            pre.setAttribute('data-src-loaded', '');
                        }
                        else if (xhr.status >= 400) {
                            code.textContent = '✖ Error ' + xhr.status + ' while fetching file: ' + xhr.statusText;
                        }
                        else {
                            code.textContent = '✖ Error: File does not exist or is empty';
                        }
                    }
                };

                xhr.send(null);
            });

            if (Prism.plugins.toolbar) {
                Prism.plugins.toolbar.registerButton('download-file', function (env) {
                    var pre = env.element.parentNode;
                    if (!pre || !/pre/i.test(pre.nodeName) || !pre.hasAttribute('data-src') || !pre.hasAttribute('data-download-link')) {
                        return;
                    }
                    var src = pre.getAttribute('data-src');
                    var a = document.createElement('a');
                    a.textContent = pre.getAttribute('data-download-link-label') || 'Download';
                    a.setAttribute('download', '');
                    a.href = src;
                    return a;
                });
            }

        };

        document.addEventListener('DOMContentLoaded', function () {
            // execute inside handler, for dropping Event as argument
            self.Prism.fileHighlight();
        });

    })();
    });

    var marked = createCommonjsModule(function (module, exports) {
        /**
         * marked - a markdown parser
         * Copyright (c) 2011-2018, Christopher Jeffrey. (MIT Licensed)
         * https://github.com/markedjs/marked
         */

        ;(function(root) {
            'use strict';

            /**
             * Block-Level Grammar
             */

            var block = {
                newline: /^\n+/,
                code: /^( {4}[^\n]+\n*)+/,
                fences: /^ {0,3}(`{3,}|~{3,})([^`~\n]*)\n(?:|([\s\S]*?)\n)(?: {0,3}\1[~`]* *(?:\n+|$)|$)/,
                hr: /^ {0,3}((?:- *){3,}|(?:_ *){3,}|(?:\* *){3,})(?:\n+|$)/,
                heading: /^ {0,3}(#{1,6}) +([^\n]*?)(?: +#+)? *(?:\n+|$)/,
                blockquote: /^( {0,3}> ?(paragraph|[^\n]*)(?:\n|$))+/,
                list: /^( {0,3})(bull) [\s\S]+?(?:hr|def|\n{2,}(?! )(?!\1bull )\n*|\s*$)/,
                html: '^ {0,3}(?:' // optional indentation
                    + '<(script|pre|style)[\\s>][\\s\\S]*?(?:</\\1>[^\\n]*\\n+|$)' // (1)
                    + '|comment[^\\n]*(\\n+|$)' // (2)
                    + '|<\\?[\\s\\S]*?\\?>\\n*' // (3)
                    + '|<![A-Z][\\s\\S]*?>\\n*' // (4)
                    + '|<!\\[CDATA\\[[\\s\\S]*?\\]\\]>\\n*' // (5)
                    + '|</?(tag)(?: +|\\n|/?>)[\\s\\S]*?(?:\\n{2,}|$)' // (6)
                    + '|<(?!script|pre|style)([a-z][\\w-]*)(?:attribute)*? */?>(?=[ \\t]*(?:\\n|$))[\\s\\S]*?(?:\\n{2,}|$)' // (7) open tag
                    + '|</(?!script|pre|style)[a-z][\\w-]*\\s*>(?=[ \\t]*(?:\\n|$))[\\s\\S]*?(?:\\n{2,}|$)' // (7) closing tag
                    + ')',
                def: /^ {0,3}\[(label)\]: *\n? *<?([^\s>]+)>?(?:(?: +\n? *| *\n *)(title))? *(?:\n+|$)/,
                nptable: noop,
                table: noop,
                lheading: /^([^\n]+)\n {0,3}(=+|-+) *(?:\n+|$)/,
                // regex template, placeholders will be replaced according to different paragraph
                // interruption rules of commonmark and the original markdown spec:
                _paragraph: /^([^\n]+(?:\n(?!hr|heading|lheading|blockquote|fences|list|html)[^\n]+)*)/,
                text: /^[^\n]+/
            };

            block._label = /(?!\s*\])(?:\\[\[\]]|[^\[\]])+/;
            block._title = /(?:"(?:\\"?|[^"\\])*"|'[^'\n]*(?:\n[^'\n]+)*\n?'|\([^()]*\))/;
            block.def = edit(block.def)
                .replace('label', block._label)
                .replace('title', block._title)
                .getRegex();

            block.bullet = /(?:[*+-]|\d{1,9}\.)/;
            block.item = /^( *)(bull) ?[^\n]*(?:\n(?!\1bull ?)[^\n]*)*/;
            block.item = edit(block.item, 'gm')
                .replace(/bull/g, block.bullet)
                .getRegex();

            block.list = edit(block.list)
                .replace(/bull/g, block.bullet)
                .replace('hr', '\\n+(?=\\1?(?:(?:- *){3,}|(?:_ *){3,}|(?:\\* *){3,})(?:\\n+|$))')
                .replace('def', '\\n+(?=' + block.def.source + ')')
                .getRegex();

            block._tag = 'address|article|aside|base|basefont|blockquote|body|caption'
                + '|center|col|colgroup|dd|details|dialog|dir|div|dl|dt|fieldset|figcaption'
                + '|figure|footer|form|frame|frameset|h[1-6]|head|header|hr|html|iframe'
                + '|legend|li|link|main|menu|menuitem|meta|nav|noframes|ol|optgroup|option'
                + '|p|param|section|source|summary|table|tbody|td|tfoot|th|thead|title|tr'
                + '|track|ul';
            block._comment = /<!--(?!-?>)[\s\S]*?-->/;
            block.html = edit(block.html, 'i')
                .replace('comment', block._comment)
                .replace('tag', block._tag)
                .replace('attribute', / +[a-zA-Z:_][\w.:-]*(?: *= *"[^"\n]*"| *= *'[^'\n]*'| *= *[^\s"'=<>`]+)?/)
                .getRegex();

            block.paragraph = edit(block._paragraph)
                .replace('hr', block.hr)
                .replace('heading', ' {0,3}#{1,6} +')
                .replace('|lheading', '') // setex headings don't interrupt commonmark paragraphs
                .replace('blockquote', ' {0,3}>')
                .replace('fences', ' {0,3}(?:`{3,}|~{3,})[^`\\n]*\\n')
                .replace('list', ' {0,3}(?:[*+-]|1[.)]) ') // only lists starting from 1 can interrupt
                .replace('html', '</?(?:tag)(?: +|\\n|/?>)|<(?:script|pre|style|!--)')
                .replace('tag', block._tag) // pars can be interrupted by type (6) html blocks
                .getRegex();

            block.blockquote = edit(block.blockquote)
                .replace('paragraph', block.paragraph)
                .getRegex();

            /**
             * Normal Block Grammar
             */

            block.normal = merge({}, block);

            /**
             * GFM Block Grammar
             */

            block.gfm = merge({}, block.normal, {
                nptable: /^ *([^|\n ].*\|.*)\n *([-:]+ *\|[-| :]*)(?:\n((?:.*[^>\n ].*(?:\n|$))*)\n*|$)/,
                table: /^ *\|(.+)\n *\|?( *[-:]+[-| :]*)(?:\n((?: *[^>\n ].*(?:\n|$))*)\n*|$)/
            });

            /**
             * Pedantic grammar (original John Gruber's loose markdown specification)
             */

            block.pedantic = merge({}, block.normal, {
                html: edit(
                    '^ *(?:comment *(?:\\n|\\s*$)'
                    + '|<(tag)[\\s\\S]+?</\\1> *(?:\\n{2,}|\\s*$)' // closed tag
                    + '|<tag(?:"[^"]*"|\'[^\']*\'|\\s[^\'"/>\\s]*)*?/?> *(?:\\n{2,}|\\s*$))')
                    .replace('comment', block._comment)
                    .replace(/tag/g, '(?!(?:'
                        + 'a|em|strong|small|s|cite|q|dfn|abbr|data|time|code|var|samp|kbd|sub'
                        + '|sup|i|b|u|mark|ruby|rt|rp|bdi|bdo|span|br|wbr|ins|del|img)'
                        + '\\b)\\w+(?!:|[^\\w\\s@]*@)\\b')
                    .getRegex(),
                def: /^ *\[([^\]]+)\]: *<?([^\s>]+)>?(?: +(["(][^\n]+[")]))? *(?:\n+|$)/,
                heading: /^ *(#{1,6}) *([^\n]+?) *(?:#+ *)?(?:\n+|$)/,
                fences: noop, // fences not supported
                paragraph: edit(block.normal._paragraph)
                    .replace('hr', block.hr)
                    .replace('heading', ' *#{1,6} *[^\n]')
                    .replace('lheading', block.lheading)
                    .replace('blockquote', ' {0,3}>')
                    .replace('|fences', '')
                    .replace('|list', '')
                    .replace('|html', '')
                    .getRegex()
            });

            /**
             * Block Lexer
             */

            function Lexer(options) {
                this.tokens = [];
                this.tokens.links = Object.create(null);
                this.options = options || marked.defaults;
                this.rules = block.normal;

                if (this.options.pedantic) {
                    this.rules = block.pedantic;
                } else if (this.options.gfm) {
                    this.rules = block.gfm;
                }
            }

            /**
             * Expose Block Rules
             */

            Lexer.rules = block;

            /**
             * Static Lex Method
             */

            Lexer.lex = function(src, options) {
                var lexer = new Lexer(options);
                return lexer.lex(src);
            };

            /**
             * Preprocessing
             */

            Lexer.prototype.lex = function(src) {
                src = src
                    .replace(/\r\n|\r/g, '\n')
                    .replace(/\t/g, '    ')
                    .replace(/\u00a0/g, ' ')
                    .replace(/\u2424/g, '\n');

                return this.token(src, true);
            };

            /**
             * Lexing
             */

            Lexer.prototype.token = function(src, top) {
                src = src.replace(/^ +$/gm, '');
                var next,
                    loose,
                    cap,
                    bull,
                    b,
                    item,
                    listStart,
                    listItems,
                    t,
                    space,
                    i,
                    tag,
                    l,
                    isordered,
                    istask,
                    ischecked;

                while (src) {
                    // newline
                    if (cap = this.rules.newline.exec(src)) {
                        src = src.substring(cap[0].length);
                        if (cap[0].length > 1) {
                            this.tokens.push({
                                type: 'space'
                            });
                        }
                    }

                    // code
                    if (cap = this.rules.code.exec(src)) {
                        var lastToken = this.tokens[this.tokens.length - 1];
                        src = src.substring(cap[0].length);
                        // An indented code block cannot interrupt a paragraph.
                        if (lastToken && lastToken.type === 'paragraph') {
                            lastToken.text += '\n' + cap[0].trimRight();
                        } else {
                            cap = cap[0].replace(/^ {4}/gm, '');
                            this.tokens.push({
                                type: 'code',
                                codeBlockStyle: 'indented',
                                text: !this.options.pedantic
                                    ? rtrim(cap, '\n')
                                    : cap
                            });
                        }
                        continue;
                    }

                    // fences
                    if (cap = this.rules.fences.exec(src)) {
                        src = src.substring(cap[0].length);
                        this.tokens.push({
                            type: 'code',
                            lang: cap[2] ? cap[2].trim() : cap[2],
                            text: cap[3] || ''
                        });
                        continue;
                    }

                    // heading
                    if (cap = this.rules.heading.exec(src)) {
                        src = src.substring(cap[0].length);
                        this.tokens.push({
                            type: 'heading',
                            depth: cap[1].length,
                            text: cap[2]
                        });
                        continue;
                    }

                    // table no leading pipe (gfm)
                    if (cap = this.rules.nptable.exec(src)) {
                        item = {
                            type: 'table',
                            header: splitCells(cap[1].replace(/^ *| *\| *$/g, '')),
                            align: cap[2].replace(/^ *|\| *$/g, '').split(/ *\| */),
                            cells: cap[3] ? cap[3].replace(/\n$/, '').split('\n') : []
                        };

                        if (item.header.length === item.align.length) {
                            src = src.substring(cap[0].length);

                            for (i = 0; i < item.align.length; i++) {
                                if (/^ *-+: *$/.test(item.align[i])) {
                                    item.align[i] = 'right';
                                } else if (/^ *:-+: *$/.test(item.align[i])) {
                                    item.align[i] = 'center';
                                } else if (/^ *:-+ *$/.test(item.align[i])) {
                                    item.align[i] = 'left';
                                } else {
                                    item.align[i] = null;
                                }
                            }

                            for (i = 0; i < item.cells.length; i++) {
                                item.cells[i] = splitCells(item.cells[i], item.header.length);
                            }

                            this.tokens.push(item);

                            continue;
                        }
                    }

                    // hr
                    if (cap = this.rules.hr.exec(src)) {
                        src = src.substring(cap[0].length);
                        this.tokens.push({
                            type: 'hr'
                        });
                        continue;
                    }

                    // blockquote
                    if (cap = this.rules.blockquote.exec(src)) {
                        src = src.substring(cap[0].length);

                        this.tokens.push({
                            type: 'blockquote_start'
                        });

                        cap = cap[0].replace(/^ *> ?/gm, '');

                        // Pass `top` to keep the current
                        // "toplevel" state. This is exactly
                        // how markdown.pl works.
                        this.token(cap, top);

                        this.tokens.push({
                            type: 'blockquote_end'
                        });

                        continue;
                    }

                    // list
                    if (cap = this.rules.list.exec(src)) {
                        src = src.substring(cap[0].length);
                        bull = cap[2];
                        isordered = bull.length > 1;

                        listStart = {
                            type: 'list_start',
                            ordered: isordered,
                            start: isordered ? +bull : '',
                            loose: false
                        };

                        this.tokens.push(listStart);

                        // Get each top-level item.
                        cap = cap[0].match(this.rules.item);

                        listItems = [];
                        next = false;
                        l = cap.length;
                        i = 0;

                        for (; i < l; i++) {
                            item = cap[i];

                            // Remove the list item's bullet
                            // so it is seen as the next token.
                            space = item.length;
                            item = item.replace(/^ *([*+-]|\d+\.) */, '');

                            // Outdent whatever the
                            // list item contains. Hacky.
                            if (~item.indexOf('\n ')) {
                                space -= item.length;
                                item = !this.options.pedantic
                                    ? item.replace(new RegExp('^ {1,' + space + '}', 'gm'), '')
                                    : item.replace(/^ {1,4}/gm, '');
                            }

                            // Determine whether the next list item belongs here.
                            // Backpedal if it does not belong in this list.
                            if (i !== l - 1) {
                                b = block.bullet.exec(cap[i + 1])[0];
                                if (bull.length > 1 ? b.length === 1
                                    : (b.length > 1 || (this.options.smartLists && b !== bull))) {
                                    src = cap.slice(i + 1).join('\n') + src;
                                    i = l - 1;
                                }
                            }

                            // Determine whether item is loose or not.
                            // Use: /(^|\n)(?! )[^\n]+\n\n(?!\s*$)/
                            // for discount behavior.
                            loose = next || /\n\n(?!\s*$)/.test(item);
                            if (i !== l - 1) {
                                next = item.charAt(item.length - 1) === '\n';
                                if (!loose) loose = next;
                            }

                            if (loose) {
                                listStart.loose = true;
                            }

                            // Check for task list items
                            istask = /^\[[ xX]\] /.test(item);
                            ischecked = undefined;
                            if (istask) {
                                ischecked = item[1] !== ' ';
                                item = item.replace(/^\[[ xX]\] +/, '');
                            }

                            t = {
                                type: 'list_item_start',
                                task: istask,
                                checked: ischecked,
                                loose: loose
                            };

                            listItems.push(t);
                            this.tokens.push(t);

                            // Recurse.
                            this.token(item, false);

                            this.tokens.push({
                                type: 'list_item_end'
                            });
                        }

                        if (listStart.loose) {
                            l = listItems.length;
                            i = 0;
                            for (; i < l; i++) {
                                listItems[i].loose = true;
                            }
                        }

                        this.tokens.push({
                            type: 'list_end'
                        });

                        continue;
                    }

                    // html
                    if (cap = this.rules.html.exec(src)) {
                        src = src.substring(cap[0].length);
                        this.tokens.push({
                            type: this.options.sanitize
                                ? 'paragraph'
                                : 'html',
                            pre: !this.options.sanitizer
                                && (cap[1] === 'pre' || cap[1] === 'script' || cap[1] === 'style'),
                            text: this.options.sanitize ? (this.options.sanitizer ? this.options.sanitizer(cap[0]) : escape(cap[0])) : cap[0]
                        });
                        continue;
                    }

                    // def
                    if (top && (cap = this.rules.def.exec(src))) {
                        src = src.substring(cap[0].length);
                        if (cap[3]) cap[3] = cap[3].substring(1, cap[3].length - 1);
                        tag = cap[1].toLowerCase().replace(/\s+/g, ' ');
                        if (!this.tokens.links[tag]) {
                            this.tokens.links[tag] = {
                                href: cap[2],
                                title: cap[3]
                            };
                        }
                        continue;
                    }

                    // table (gfm)
                    if (cap = this.rules.table.exec(src)) {
                        item = {
                            type: 'table',
                            header: splitCells(cap[1].replace(/^ *| *\| *$/g, '')),
                            align: cap[2].replace(/^ *|\| *$/g, '').split(/ *\| */),
                            cells: cap[3] ? cap[3].replace(/\n$/, '').split('\n') : []
                        };

                        if (item.header.length === item.align.length) {
                            src = src.substring(cap[0].length);

                            for (i = 0; i < item.align.length; i++) {
                                if (/^ *-+: *$/.test(item.align[i])) {
                                    item.align[i] = 'right';
                                } else if (/^ *:-+: *$/.test(item.align[i])) {
                                    item.align[i] = 'center';
                                } else if (/^ *:-+ *$/.test(item.align[i])) {
                                    item.align[i] = 'left';
                                } else {
                                    item.align[i] = null;
                                }
                            }

                            for (i = 0; i < item.cells.length; i++) {
                                item.cells[i] = splitCells(
                                    item.cells[i].replace(/^ *\| *| *\| *$/g, ''),
                                    item.header.length);
                            }

                            this.tokens.push(item);

                            continue;
                        }
                    }

                    // lheading
                    if (cap = this.rules.lheading.exec(src)) {
                        src = src.substring(cap[0].length);
                        this.tokens.push({
                            type: 'heading',
                            depth: cap[2].charAt(0) === '=' ? 1 : 2,
                            text: cap[1]
                        });
                        continue;
                    }

                    // top-level paragraph
                    if (top && (cap = this.rules.paragraph.exec(src))) {
                        src = src.substring(cap[0].length);
                        this.tokens.push({
                            type: 'paragraph',
                            text: cap[1].charAt(cap[1].length - 1) === '\n'
                                ? cap[1].slice(0, -1)
                                : cap[1]
                        });
                        continue;
                    }

                    // text
                    if (cap = this.rules.text.exec(src)) {
                        // Top-level should never reach here.
                        src = src.substring(cap[0].length);
                        this.tokens.push({
                            type: 'text',
                            text: cap[0]
                        });
                        continue;
                    }

                    if (src) {
                        throw new Error('Infinite loop on byte: ' + src.charCodeAt(0));
                    }
                }

                return this.tokens;
            };

            /**
             * Inline-Level Grammar
             */

            var inline = {
                escape: /^\\([!"#$%&'()*+,\-./:;<=>?@\[\]\\^_`{|}~])/,
                autolink: /^<(scheme:[^\s\x00-\x1f<>]*|email)>/,
                url: noop,
                tag: '^comment'
                    + '|^</[a-zA-Z][\\w:-]*\\s*>' // self-closing tag
                    + '|^<[a-zA-Z][\\w-]*(?:attribute)*?\\s*/?>' // open tag
                    + '|^<\\?[\\s\\S]*?\\?>' // processing instruction, e.g. <?php ?>
                    + '|^<![a-zA-Z]+\\s[\\s\\S]*?>' // declaration, e.g. <!DOCTYPE html>
                    + '|^<!\\[CDATA\\[[\\s\\S]*?\\]\\]>', // CDATA section
                link: /^!?\[(label)\]\(\s*(href)(?:\s+(title))?\s*\)/,
                reflink: /^!?\[(label)\]\[(?!\s*\])((?:\\[\[\]]?|[^\[\]\\])+)\]/,
                nolink: /^!?\[(?!\s*\])((?:\[[^\[\]]*\]|\\[\[\]]|[^\[\]])*)\](?:\[\])?/,
                strong: /^__([^\s_])__(?!_)|^\*\*([^\s*])\*\*(?!\*)|^__([^\s][\s\S]*?[^\s])__(?!_)|^\*\*([^\s][\s\S]*?[^\s])\*\*(?!\*)/,
                em: /^_([^\s_])_(?!_)|^\*([^\s*<\[])\*(?!\*)|^_([^\s<][\s\S]*?[^\s_])_(?!_|[^\spunctuation])|^_([^\s_<][\s\S]*?[^\s])_(?!_|[^\spunctuation])|^\*([^\s<"][\s\S]*?[^\s\*])\*(?!\*|[^\spunctuation])|^\*([^\s*"<\[][\s\S]*?[^\s])\*(?!\*)/,
                code: /^(`+)([^`]|[^`][\s\S]*?[^`])\1(?!`)/,
                br: /^( {2,}|\\)\n(?!\s*$)/,
                del: noop,
                text: /^(`+|[^`])(?:[\s\S]*?(?:(?=[\\<!\[`*]|\b_|$)|[^ ](?= {2,}\n))|(?= {2,}\n))/
            };

            // list of punctuation marks from common mark spec
            // without ` and ] to workaround Rule 17 (inline code blocks/links)
            inline._punctuation = '!"#$%&\'()*+,\\-./:;<=>?@\\[^_{|}~';
            inline.em = edit(inline.em).replace(/punctuation/g, inline._punctuation).getRegex();

            inline._escapes = /\\([!"#$%&'()*+,\-./:;<=>?@\[\]\\^_`{|}~])/g;

            inline._scheme = /[a-zA-Z][a-zA-Z0-9+.-]{1,31}/;
            inline._email = /[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+(@)[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+(?![-_])/;
            inline.autolink = edit(inline.autolink)
                .replace('scheme', inline._scheme)
                .replace('email', inline._email)
                .getRegex();

            inline._attribute = /\s+[a-zA-Z:_][\w.:-]*(?:\s*=\s*"[^"]*"|\s*=\s*'[^']*'|\s*=\s*[^\s"'=<>`]+)?/;

            inline.tag = edit(inline.tag)
                .replace('comment', block._comment)
                .replace('attribute', inline._attribute)
                .getRegex();

            inline._label = /(?:\[[^\[\]]*\]|\\.|`[^`]*`|[^\[\]\\`])*?/;
            inline._href = /<(?:\\[<>]?|[^\s<>\\])*>|[^\s\x00-\x1f]*/;
            inline._title = /"(?:\\"?|[^"\\])*"|'(?:\\'?|[^'\\])*'|\((?:\\\)?|[^)\\])*\)/;

            inline.link = edit(inline.link)
                .replace('label', inline._label)
                .replace('href', inline._href)
                .replace('title', inline._title)
                .getRegex();

            inline.reflink = edit(inline.reflink)
                .replace('label', inline._label)
                .getRegex();

            /**
             * Normal Inline Grammar
             */

            inline.normal = merge({}, inline);

            /**
             * Pedantic Inline Grammar
             */

            inline.pedantic = merge({}, inline.normal, {
                strong: /^__(?=\S)([\s\S]*?\S)__(?!_)|^\*\*(?=\S)([\s\S]*?\S)\*\*(?!\*)/,
                em: /^_(?=\S)([\s\S]*?\S)_(?!_)|^\*(?=\S)([\s\S]*?\S)\*(?!\*)/,
                link: edit(/^!?\[(label)\]\((.*?)\)/)
                    .replace('label', inline._label)
                    .getRegex(),
                reflink: edit(/^!?\[(label)\]\s*\[([^\]]*)\]/)
                    .replace('label', inline._label)
                    .getRegex()
            });

            /**
             * GFM Inline Grammar
             */

            inline.gfm = merge({}, inline.normal, {
                escape: edit(inline.escape).replace('])', '~|])').getRegex(),
                _extended_email: /[A-Za-z0-9._+-]+(@)[a-zA-Z0-9-_]+(?:\.[a-zA-Z0-9-_]*[a-zA-Z0-9])+(?![-_])/,
                url: /^((?:ftp|https?):\/\/|www\.)(?:[a-zA-Z0-9\-]+\.?)+[^\s<]*|^email/,
                _backpedal: /(?:[^?!.,:;*_~()&]+|\([^)]*\)|&(?![a-zA-Z0-9]+;$)|[?!.,:;*_~)]+(?!$))+/,
                del: /^~+(?=\S)([\s\S]*?\S)~+/,
                text: /^(`+|[^`])(?:[\s\S]*?(?:(?=[\\<!\[`*~]|\b_|https?:\/\/|ftp:\/\/|www\.|$)|[^ ](?= {2,}\n)|[^a-zA-Z0-9.!#$%&'*+\/=?_`{\|}~-](?=[a-zA-Z0-9.!#$%&'*+\/=?_`{\|}~-]+@))|(?= {2,}\n|[a-zA-Z0-9.!#$%&'*+\/=?_`{\|}~-]+@))/
            });

            inline.gfm.url = edit(inline.gfm.url, 'i')
                .replace('email', inline.gfm._extended_email)
                .getRegex();
            /**
             * GFM + Line Breaks Inline Grammar
             */

            inline.breaks = merge({}, inline.gfm, {
                br: edit(inline.br).replace('{2,}', '*').getRegex(),
                text: edit(inline.gfm.text)
                    .replace('\\b_', '\\b_| {2,}\\n')
                    .replace(/\{2,\}/g, '*')
                        .getRegex()
            });

            /**
             * Inline Lexer & Compiler
             */

            function InlineLexer(links, options) {
                this.options = options || marked.defaults;
                this.links = links;
                this.rules = inline.normal;
                this.renderer = this.options.renderer || new Renderer();
                this.renderer.options = this.options;

                if (!this.links) {
                    throw new Error('Tokens array requires a `links` property.');
                }

                if (this.options.pedantic) {
                    this.rules = inline.pedantic;
                } else if (this.options.gfm) {
                    if (this.options.breaks) {
                        this.rules = inline.breaks;
                    } else {
                        this.rules = inline.gfm;
                    }
                }
            }

            /**
             * Expose Inline Rules
             */

            InlineLexer.rules = inline;

            /**
             * Static Lexing/Compiling Method
             */

            InlineLexer.output = function(src, links, options) {
                var inline = new InlineLexer(links, options);
                return inline.output(src);
            };

            /**
             * Lexing/Compiling
             */

            InlineLexer.prototype.output = function(src) {
                var out = '',
                    link,
                    text,
                    href,
                    title,
                    cap,
                    prevCapZero;

                while (src) {
                    // escape
                    if (cap = this.rules.escape.exec(src)) {
                        src = src.substring(cap[0].length);
                        out += escape(cap[1]);
                        continue;
                    }

                    // tag
                    if (cap = this.rules.tag.exec(src)) {
                        if (!this.inLink && /^<a /i.test(cap[0])) {
                            this.inLink = true;
                        } else if (this.inLink && /^<\/a>/i.test(cap[0])) {
                            this.inLink = false;
                        }
                        if (!this.inRawBlock && /^<(pre|code|kbd|script)(\s|>)/i.test(cap[0])) {
                            this.inRawBlock = true;
                        } else if (this.inRawBlock && /^<\/(pre|code|kbd|script)(\s|>)/i.test(cap[0])) {
                            this.inRawBlock = false;
                        }

                        src = src.substring(cap[0].length);
                        out += this.options.sanitize
                            ? this.options.sanitizer
                                ? this.options.sanitizer(cap[0])
                                : escape(cap[0])
                            : cap[0];
                        continue;
                    }

                    // link
                    if (cap = this.rules.link.exec(src)) {
                        var lastParenIndex = findClosingBracket(cap[2], '()');
                        if (lastParenIndex > -1) {
                            var linkLen = 4 + cap[1].length + lastParenIndex;
                            cap[2] = cap[2].substring(0, lastParenIndex);
                            cap[0] = cap[0].substring(0, linkLen).trim();
                            cap[3] = '';
                        }
                        src = src.substring(cap[0].length);
                        this.inLink = true;
                        href = cap[2];
                        if (this.options.pedantic) {
                            link = /^([^'"]*[^\s])\s+(['"])(.*)\2/.exec(href);

                            if (link) {
                                href = link[1];
                                title = link[3];
                            } else {
                                title = '';
                            }
                        } else {
                            title = cap[3] ? cap[3].slice(1, -1) : '';
                        }
                        href = href.trim().replace(/^<([\s\S]*)>$/, '$1');
                        out += this.outputLink(cap, {
                            href: InlineLexer.escapes(href),
                            title: InlineLexer.escapes(title)
                        });
                        this.inLink = false;
                        continue;
                    }

                    // reflink, nolink
                    if ((cap = this.rules.reflink.exec(src))
                        || (cap = this.rules.nolink.exec(src))) {
                        src = src.substring(cap[0].length);
                        link = (cap[2] || cap[1]).replace(/\s+/g, ' ');
                        link = this.links[link.toLowerCase()];
                        if (!link || !link.href) {
                            out += cap[0].charAt(0);
                            src = cap[0].substring(1) + src;
                            continue;
                        }
                        this.inLink = true;
                        out += this.outputLink(cap, link);
                        this.inLink = false;
                        continue;
                    }

                    // strong
                    if (cap = this.rules.strong.exec(src)) {
                        src = src.substring(cap[0].length);
                        out += this.renderer.strong(this.output(cap[4] || cap[3] || cap[2] || cap[1]));
                        continue;
                    }

                    // em
                    if (cap = this.rules.em.exec(src)) {
                        src = src.substring(cap[0].length);
                        out += this.renderer.em(this.output(cap[6] || cap[5] || cap[4] || cap[3] || cap[2] || cap[1]));
                        continue;
                    }

                    // code
                    if (cap = this.rules.code.exec(src)) {
                        src = src.substring(cap[0].length);
                        out += this.renderer.codespan(escape(cap[2].trim(), true));
                        continue;
                    }

                    // br
                    if (cap = this.rules.br.exec(src)) {
                        src = src.substring(cap[0].length);
                        out += this.renderer.br();
                        continue;
                    }

                    // del (gfm)
                    if (cap = this.rules.del.exec(src)) {
                        src = src.substring(cap[0].length);
                        out += this.renderer.del(this.output(cap[1]));
                        continue;
                    }

                    // autolink
                    if (cap = this.rules.autolink.exec(src)) {
                        src = src.substring(cap[0].length);
                        if (cap[2] === '@') {
                            text = escape(this.mangle(cap[1]));
                            href = 'mailto:' + text;
                        } else {
                            text = escape(cap[1]);
                            href = text;
                        }
                        out += this.renderer.link(href, null, text);
                        continue;
                    }

                    // url (gfm)
                    if (!this.inLink && (cap = this.rules.url.exec(src))) {
                        if (cap[2] === '@') {
                            text = escape(cap[0]);
                            href = 'mailto:' + text;
                        } else {
                            // do extended autolink path validation
                            do {
                                prevCapZero = cap[0];
                                cap[0] = this.rules._backpedal.exec(cap[0])[0];
                            } while (prevCapZero !== cap[0]);
                            text = escape(cap[0]);
                            if (cap[1] === 'www.') {
                                href = 'http://' + text;
                            } else {
                                href = text;
                            }
                        }
                        src = src.substring(cap[0].length);
                        out += this.renderer.link(href, null, text);
                        continue;
                    }

                    // text
                    if (cap = this.rules.text.exec(src)) {
                        src = src.substring(cap[0].length);
                        if (this.inRawBlock) {
                            out += this.renderer.text(this.options.sanitize ? (this.options.sanitizer ? this.options.sanitizer(cap[0]) : escape(cap[0])) : cap[0]);
                        } else {
                            out += this.renderer.text(escape(this.smartypants(cap[0])));
                        }
                        continue;
                    }

                    if (src) {
                        throw new Error('Infinite loop on byte: ' + src.charCodeAt(0));
                    }
                }

                return out;
            };

            InlineLexer.escapes = function(text) {
                return text ? text.replace(InlineLexer.rules._escapes, '$1') : text;
            };

            /**
             * Compile Link
             */

            InlineLexer.prototype.outputLink = function(cap, link) {
                var href = link.href,
                    title = link.title ? escape(link.title) : null;

                return cap[0].charAt(0) !== '!'
                    ? this.renderer.link(href, title, this.output(cap[1]))
                    : this.renderer.image(href, title, escape(cap[1]));
            };

            /**
             * Smartypants Transformations
             */

            InlineLexer.prototype.smartypants = function(text) {
                if (!this.options.smartypants) return text;
                return text
                // em-dashes
                    .replace(/---/g, '\u2014')
                    // en-dashes
                    .replace(/--/g, '\u2013')
                    // opening singles
                    .replace(/(^|[-\u2014/(\[{"\s])'/g, '$1\u2018')
        // closing singles & apostrophes
        .replace(/'/g, '\u2019')
        // opening doubles
        .replace(/(^|[-\u2014/(\[{\u2018\s])"/g, '$1\u201c')
        // closing doubles
        .replace(/"/g, '\u201d')
                            // ellipses
                            .replace(/\.{3}/g, '\u2026');
                            };

                            /**
                            * Mangle Links
                            */

                            InlineLexer.prototype.mangle = function(text) {
                            if (!this.options.mangle) return text;
                            var out = '',
                            l = text.length,
                            i = 0,
                            ch;

                            for (; i < l; i++) {
                            ch = text.charCodeAt(i);
                            if (Math.random() > 0.5) {
                            ch = 'x' + ch.toString(16);
                            }
                            out += '&#' + ch + ';';
                            }

      return out;
    };

    /**
     * Renderer
     */

    function Renderer(options) {
      this.options = options || marked.defaults;
    }

    Renderer.prototype.code = function(code, infostring, escaped) {
      var lang = (infostring || '').match(/\S*/)[0];
                if (this.options.highlight) {
                    var out = this.options.highlight(code, lang);
                    if (out != null && out !== code) {
                        escaped = true;
                        code = out;
                    }
                }

                if (!lang) {
                    return '<pre><code>'
                        + (escaped ? code : escape(code, true))
                        + '</code></pre>';
                }

                return '<pre><code class="'
                    + this.options.langPrefix
                    + escape(lang, true)
                    + '">'
                    + (escaped ? code : escape(code, true))
                    + '</code></pre>\n';
            };

            Renderer.prototype.blockquote = function(quote) {
                return '<blockquote>\n' + quote + '</blockquote>\n';
            };

            Renderer.prototype.html = function(html) {
                return html;
            };

            Renderer.prototype.heading = function(text, level, raw, slugger) {
                if (this.options.headerIds) {
                    return '<h'
                        + level
                        + ' id="'
                        + this.options.headerPrefix
                        + slugger.slug(raw)
                        + '">'
                        + text
                        + '</h'
                        + level
                        + '>\n';
                }
                // ignore IDs
                return '<h' + level + '>' + text + '</h' + level + '>\n';
            };

            Renderer.prototype.hr = function() {
                return this.options.xhtml ? '<hr/>\n' : '<hr>\n';
            };

            Renderer.prototype.list = function(body, ordered, start) {
                var type = ordered ? 'ol' : 'ul',
                    startatt = (ordered && start !== 1) ? (' start="' + start + '"') : '';
                return '<' + type + startatt + '>\n' + body + '</' + type + '>\n';
            };

            Renderer.prototype.listitem = function(text) {
                return '<li>' + text + '</li>\n';
            };

            Renderer.prototype.checkbox = function(checked) {
                return '<input '
                    + (checked ? 'checked="" ' : '')
                    + 'disabled="" type="checkbox"'
                    + (this.options.xhtml ? ' /' : '')
                    + '> ';
            };

            Renderer.prototype.paragraph = function(text) {
                return '<p>' + text + '</p>\n';
            };

            Renderer.prototype.table = function(header, body) {
                if (body) body = '<tbody>' + body + '</tbody>';

                return '<table>\n'
                    + '<thead>\n'
                    + header
                    + '</thead>\n'
                    + body
                    + '</table>\n';
            };

            Renderer.prototype.tablerow = function(content) {
                return '<tr>\n' + content + '</tr>\n';
            };

            Renderer.prototype.tablecell = function(content, flags) {
                var type = flags.header ? 'th' : 'td';
                var tag = flags.align
                    ? '<' + type + ' align="' + flags.align + '">'
                    : '<' + type + '>';
                return tag + content + '</' + type + '>\n';
            };

            // span level renderer
            Renderer.prototype.strong = function(text) {
                return '<strong>' + text + '</strong>';
            };

            Renderer.prototype.em = function(text) {
                return '<em>' + text + '</em>';
            };

            Renderer.prototype.codespan = function(text) {
                return '<code>' + text + '</code>';
            };

            Renderer.prototype.br = function() {
                return this.options.xhtml ? '<br/>' : '<br>';
            };

            Renderer.prototype.del = function(text) {
                return '<del>' + text + '</del>';
            };

            Renderer.prototype.link = function(href, title, text) {
                href = cleanUrl(this.options.sanitize, this.options.baseUrl, href);
                if (href === null) {
                    return text;
                }
                var out = '<a href="' + escape(href) + '"';
                if (title) {
                    out += ' title="' + title + '"';
                }
                out += '>' + text + '</a>';
                return out;
            };

            Renderer.prototype.image = function(href, title, text) {
                href = cleanUrl(this.options.sanitize, this.options.baseUrl, href);
                if (href === null) {
                    return text;
                }

                var out = '<img src="' + href + '" alt="' + text + '"';
                if (title) {
                    out += ' title="' + title + '"';
                }
                out += this.options.xhtml ? '/>' : '>';
                return out;
            };

            Renderer.prototype.text = function(text) {
                return text;
            };

            /**
             * TextRenderer
             * returns only the textual part of the token
             */

            function TextRenderer() {}

            // no need for block level renderers

            TextRenderer.prototype.strong =
                TextRenderer.prototype.em =
                    TextRenderer.prototype.codespan =
                        TextRenderer.prototype.del =
                            TextRenderer.prototype.text = function(text) {
                                return text;
                            };

            TextRenderer.prototype.link =
                TextRenderer.prototype.image = function(href, title, text) {
                    return '' + text;
                };

            TextRenderer.prototype.br = function() {
                return '';
            };

            /**
             * Parsing & Compiling
             */

            function Parser(options) {
                this.tokens = [];
                this.token = null;
                this.options = options || marked.defaults;
                this.options.renderer = this.options.renderer || new Renderer();
                this.renderer = this.options.renderer;
                this.renderer.options = this.options;
                this.slugger = new Slugger();
            }

            /**
             * Static Parse Method
             */

            Parser.parse = function(src, options) {
                var parser = new Parser(options);
                return parser.parse(src);
            };

            /**
             * Parse Loop
             */

            Parser.prototype.parse = function(src) {
                this.inline = new InlineLexer(src.links, this.options);
                // use an InlineLexer with a TextRenderer to extract pure text
                this.inlineText = new InlineLexer(
                    src.links,
                    merge({}, this.options, { renderer: new TextRenderer() })
                );
                this.tokens = src.reverse();

                var out = '';
                while (this.next()) {
                    out += this.tok();
                }

                return out;
            };

            /**
             * Next Token
             */

            Parser.prototype.next = function() {
                this.token = this.tokens.pop();
                return this.token;
            };

            /**
             * Preview Next Token
             */

            Parser.prototype.peek = function() {
                return this.tokens[this.tokens.length - 1] || 0;
            };

            /**
             * Parse Text Tokens
             */

            Parser.prototype.parseText = function() {
                var body = this.token.text;

                while (this.peek().type === 'text') {
                    body += '\n' + this.next().text;
                }

                return this.inline.output(body);
            };

            /**
             * Parse Current Token
             */

            Parser.prototype.tok = function() {
                switch (this.token.type) {
                    case 'space': {
                        return '';
                    }
                    case 'hr': {
                        return this.renderer.hr();
                    }
                    case 'heading': {
                        return this.renderer.heading(
                            this.inline.output(this.token.text),
                            this.token.depth,
                            unescape(this.inlineText.output(this.token.text)),
                            this.slugger);
                    }
                    case 'code': {
                        return this.renderer.code(this.token.text,
                            this.token.lang,
                            this.token.escaped);
                    }
                    case 'table': {
                        var header = '',
                            body = '',
                            i,
                            row,
                            cell,
                            j;

                        // header
                        cell = '';
                        for (i = 0; i < this.token.header.length; i++) {
                            cell += this.renderer.tablecell(
                                this.inline.output(this.token.header[i]),
                                { header: true, align: this.token.align[i] }
                            );
                        }
                        header += this.renderer.tablerow(cell);

                        for (i = 0; i < this.token.cells.length; i++) {
                            row = this.token.cells[i];

                            cell = '';
                            for (j = 0; j < row.length; j++) {
                                cell += this.renderer.tablecell(
                                    this.inline.output(row[j]),
                                    { header: false, align: this.token.align[j] }
                                );
                            }

                            body += this.renderer.tablerow(cell);
                        }
                        return this.renderer.table(header, body);
                    }
                    case 'blockquote_start': {
                        body = '';

                        while (this.next().type !== 'blockquote_end') {
                            body += this.tok();
                        }

                        return this.renderer.blockquote(body);
                    }
                    case 'list_start': {
                        body = '';
                        var ordered = this.token.ordered,
                            start = this.token.start;

                        while (this.next().type !== 'list_end') {
                            body += this.tok();
                        }

                        return this.renderer.list(body, ordered, start);
                    }
                    case 'list_item_start': {
                        body = '';
                        var loose = this.token.loose;
                        var checked = this.token.checked;
                        var task = this.token.task;

                        if (this.token.task) {
                            body += this.renderer.checkbox(checked);
                        }

                        while (this.next().type !== 'list_item_end') {
                            body += !loose && this.token.type === 'text'
                                ? this.parseText()
                                : this.tok();
                        }
                        return this.renderer.listitem(body, task, checked);
                    }
                    case 'html': {
                        // TODO parse inline content if parameter markdown=1
                        return this.renderer.html(this.token.text);
                    }
                    case 'paragraph': {
                        return this.renderer.paragraph(this.inline.output(this.token.text));
                    }
                    case 'text': {
                        return this.renderer.paragraph(this.parseText());
                    }
                    default: {
                        var errMsg = 'Token with "' + this.token.type + '" type was not found.';
                        if (this.options.silent) {
                            console.log(errMsg);
                        } else {
                            throw new Error(errMsg);
                        }
                    }
                }
            };

            /**
             * Slugger generates header id
             */

            function Slugger() {
                this.seen = {};
            }

            /**
             * Convert string to unique id
             */

            Slugger.prototype.slug = function(value) {
                var slug = value
                    .toLowerCase()
                    .trim()
                    .replace(/[\u2000-\u206F\u2E00-\u2E7F\\'!"#$%&()*+,./:;<=>?@[\]^`{|}~]/g, '')
                    .replace(/\s/g, '-');

                if (this.seen.hasOwnProperty(slug)) {
                    var originalSlug = slug;
                    do {
                        this.seen[originalSlug]++;
                        slug = originalSlug + '-' + this.seen[originalSlug];
                    } while (this.seen.hasOwnProperty(slug));
                }
                this.seen[slug] = 0;

                return slug;
            };

            /**
             * Helpers
             */

            function escape(html, encode) {
                if (encode) {
                    if (escape.escapeTest.test(html)) {
                        return html.replace(escape.escapeReplace, function(ch) { return escape.replacements[ch]; });
                    }
                } else {
                    if (escape.escapeTestNoEncode.test(html)) {
                        return html.replace(escape.escapeReplaceNoEncode, function(ch) { return escape.replacements[ch]; });
                    }
                }

                return html;
            }

            escape.escapeTest = /[&<>"']/;
            escape.escapeReplace = /[&<>"']/g;
            escape.replacements = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#39;'
            };

            escape.escapeTestNoEncode = /[<>"']|&(?!#?\w+;)/;
            escape.escapeReplaceNoEncode = /[<>"']|&(?!#?\w+;)/g;

            function unescape(html) {
                // explicitly match decimal, hex, and named HTML entities
                return html.replace(/&(#(?:\d+)|(?:#x[0-9A-Fa-f]+)|(?:\w+));?/ig, function(_, n) {
                    n = n.toLowerCase();
                    if (n === 'colon') return ':';
                    if (n.charAt(0) === '#') {
                        return n.charAt(1) === 'x'
                            ? String.fromCharCode(parseInt(n.substring(2), 16))
                            : String.fromCharCode(+n.substring(1));
                    }
                    return '';
                });
            }

            function edit(regex, opt) {
                regex = regex.source || regex;
                opt = opt || '';
                return {
                    replace: function(name, val) {
                        val = val.source || val;
                        val = val.replace(/(^|[^\[])\^/g, '$1');
                        regex = regex.replace(name, val);
                        return this;
                    },
                    getRegex: function() {
                        return new RegExp(regex, opt);
                    }
                };
            }

            function cleanUrl(sanitize, base, href) {
                if (sanitize) {
                    try {
                        var prot = decodeURIComponent(unescape(href))
                            .replace(/[^\w:]/g, '')
                            .toLowerCase();
                    } catch (e) {
                        return null;
                    }
                    if (prot.indexOf('javascript:') === 0 || prot.indexOf('vbscript:') === 0 || prot.indexOf('data:') === 0) {
                        return null;
                    }
                }
                if (base && !originIndependentUrl.test(href)) {
                    href = resolveUrl(base, href);
                }
                try {
                    href = encodeURI(href).replace(/%25/g, '%');
                } catch (e) {
                    return null;
                }
                return href;
            }

            function resolveUrl(base, href) {
                if (!baseUrls[' ' + base]) {
                    // we can ignore everything in base after the last slash of its path component,
                    // but we might need to add _that_
                    // https://tools.ietf.org/html/rfc3986#section-3
                    if (/^[^:]+:\/*[^/]*$/.test(base)) {
                        baseUrls[' ' + base] = base + '/';
                    } else {
                        baseUrls[' ' + base] = rtrim(base, '/', true);
                    }
                }
                base = baseUrls[' ' + base];

                if (href.slice(0, 2) === '//') {
                    return base.replace(/:[\s\S]*/, ':') + href;
                } else if (href.charAt(0) === '/') {
                    return base.replace(/(:\/*[^/]*)[\s\S]*/, '$1') + href;
                } else {
                    return base + href;
                }
            }
            var baseUrls = {};
            var originIndependentUrl = /^$|^[a-z][a-z0-9+.-]*:|^[?#]/i;

            function noop() {}
            noop.exec = noop;

            function merge(obj) {
                var i = 1,
                    target,
                    key;

                for (; i < arguments.length; i++) {
                    target = arguments[i];
                    for (key in target) {
                        if (Object.prototype.hasOwnProperty.call(target, key)) {
                            obj[key] = target[key];
                        }
                    }
                }

                return obj;
            }

            function splitCells(tableRow, count) {
                // ensure that every cell-delimiting pipe has a space
                // before it to distinguish it from an escaped pipe
                var row = tableRow.replace(/\|/g, function(match, offset, str) {
                        var escaped = false,
                            curr = offset;
                        while (--curr >= 0 && str[curr] === '\\') escaped = !escaped;
                        if (escaped) {
                            // odd number of slashes means | is escaped
                            // so we leave it alone
                            return '|';
                        } else {
                            // add space before unescaped |
                            return ' |';
                        }
                    }),
                    cells = row.split(/ \|/),
                    i = 0;

                if (cells.length > count) {
                    cells.splice(count);
                } else {
                    while (cells.length < count) cells.push('');
                }

                for (; i < cells.length; i++) {
                    // leading or trailing whitespace is ignored per the gfm spec
                    cells[i] = cells[i].trim().replace(/\\\|/g, '|');
                }
                return cells;
            }

            // Remove trailing 'c's. Equivalent to str.replace(/c*$/, '').
            // /c*$/ is vulnerable to REDOS.
            // invert: Remove suffix of non-c chars instead. Default falsey.
            function rtrim(str, c, invert) {
                if (str.length === 0) {
                    return '';
                }

                // Length of suffix matching the invert condition.
                var suffLen = 0;

                // Step left until we fail to match the invert condition.
                while (suffLen < str.length) {
                    var currChar = str.charAt(str.length - suffLen - 1);
                    if (currChar === c && !invert) {
                        suffLen++;
                    } else if (currChar !== c && invert) {
                        suffLen++;
                    } else {
                        break;
                    }
                }

                return str.substr(0, str.length - suffLen);
            }

            function findClosingBracket(str, b) {
                if (str.indexOf(b[1]) === -1) {
                    return -1;
                }
                var level = 0;
                for (var i = 0; i < str.length; i++) {
                    if (str[i] === '\\') {
                        i++;
                    } else if (str[i] === b[0]) {
                        level++;
                    } else if (str[i] === b[1]) {
                        level--;
                        if (level < 0) {
                            return i;
                        }
                    }
                }
                return -1;
            }

            function checkSanitizeDeprecation(opt) {
                if (opt && opt.sanitize && !opt.silent) {
                    console.warn('marked(): sanitize and sanitizer parameters are deprecated since version 0.7.0, should not be used and will be removed in the future. Read more here: https://marked.js.org/#/USING_ADVANCED.md#options');
                }
            }

            /**
             * Marked
             */

            function marked(src, opt, callback) {
                // throw error in case of non string input
                if (typeof src === 'undefined' || src === null) {
                    throw new Error('marked(): input parameter is undefined or null');
                }
                if (typeof src !== 'string') {
                    throw new Error('marked(): input parameter is of type '
                        + Object.prototype.toString.call(src) + ', string expected');
                }

                if (callback || typeof opt === 'function') {
                    if (!callback) {
                        callback = opt;
                        opt = null;
                    }

                    opt = merge({}, marked.defaults, opt || {});
                    checkSanitizeDeprecation(opt);

                    var highlight = opt.highlight,
                        tokens,
                        pending,
                        i = 0;

                    try {
                        tokens = Lexer.lex(src, opt);
                    } catch (e) {
                        return callback(e);
                    }

                    pending = tokens.length;

                    var done = function(err) {
                        if (err) {
                            opt.highlight = highlight;
                            return callback(err);
                        }

                        var out;

                        try {
                            out = Parser.parse(tokens, opt);
                        } catch (e) {
                            err = e;
                        }

                        opt.highlight = highlight;

                        return err
                            ? callback(err)
                            : callback(null, out);
                    };

                    if (!highlight || highlight.length < 3) {
                        return done();
                    }

                    delete opt.highlight;

                    if (!pending) return done();

                    for (; i < tokens.length; i++) {
                        (function(token) {
                            if (token.type !== 'code') {
                                return --pending || done();
                            }
                            return highlight(token.text, token.lang, function(err, code) {
                                if (err) return done(err);
                                if (code == null || code === token.text) {
                                    return --pending || done();
                                }
                                token.text = code;
                                token.escaped = true;
                                --pending || done();
                            });
                        })(tokens[i]);
                    }

                    return;
                }
                try {
                    if (opt) opt = merge({}, marked.defaults, opt);
                    checkSanitizeDeprecation(opt);
                    return Parser.parse(Lexer.lex(src, opt), opt);
                } catch (e) {
                    e.message += '\nPlease report this to https://github.com/markedjs/marked.';
                    if ((opt || marked.defaults).silent) {
                        return '<p>An error occurred:</p><pre>'
                            + escape(e.message + '', true)
                            + '</pre>';
                    }
                    throw e;
                }
            }

            /**
             * Options
             */

            marked.options =
                marked.setOptions = function(opt) {
                    merge(marked.defaults, opt);
                    return marked;
                };

            marked.getDefaults = function() {
                return {
                    baseUrl: null,
                    breaks: false,
                    gfm: true,
                    headerIds: true,
                    headerPrefix: '',
                    highlight: null,
                    langPrefix: 'language-',
                    mangle: true,
                    pedantic: false,
                    renderer: new Renderer(),
                    sanitize: false,
                    sanitizer: null,
                    silent: false,
                    smartLists: false,
                    smartypants: false,
                    xhtml: false
                };
            };

            marked.defaults = marked.getDefaults();

            /**
             * Expose
             */

            marked.Parser = Parser;
            marked.parser = Parser.parse;

            marked.Renderer = Renderer;
            marked.TextRenderer = TextRenderer;

            marked.Lexer = Lexer;
            marked.lexer = Lexer.lex;

            marked.InlineLexer = InlineLexer;
            marked.inlineLexer = InlineLexer.output;

            marked.Slugger = Slugger;

            marked.parse = marked;

            if ('object' !== 'undefined' && 'object' === 'object') {
                module.exports = marked;
            } else if (typeof undefined === 'function' && undefined.amd) {
                undefined(function() { return marked; });
            } else {
                root.marked = marked;
            }
        })(commonjsGlobal || (typeof window !== 'undefined' ? window : commonjsGlobal));
    });

    var speakingurl = createCommonjsModule(function (module) {
        (function (root) {
            'use strict';

            /**
             * charMap
             * @type {Object}
             */
            var charMap = {

                // latin
                'À': 'A',
                'Á': 'A',
                'Â': 'A',
                'Ã': 'A',
                'Ä': 'Ae',
                'Å': 'A',
                'Æ': 'AE',
                'Ç': 'C',
                'È': 'E',
                'É': 'E',
                'Ê': 'E',
                'Ë': 'E',
                'Ì': 'I',
                'Í': 'I',
                'Î': 'I',
                'Ï': 'I',
                'Ð': 'D',
                'Ñ': 'N',
                'Ò': 'O',
                'Ó': 'O',
                'Ô': 'O',
                'Õ': 'O',
                'Ö': 'Oe',
                'Ő': 'O',
                'Ø': 'O',
                'Ù': 'U',
                'Ú': 'U',
                'Û': 'U',
                'Ü': 'Ue',
                'Ű': 'U',
                'Ý': 'Y',
                'Þ': 'TH',
                'ß': 'ss',
                'à': 'a',
                'á': 'a',
                'â': 'a',
                'ã': 'a',
                'ä': 'ae',
                'å': 'a',
                'æ': 'ae',
                'ç': 'c',
                'è': 'e',
                'é': 'e',
                'ê': 'e',
                'ë': 'e',
                'ì': 'i',
                'í': 'i',
                'î': 'i',
                'ï': 'i',
                'ð': 'd',
                'ñ': 'n',
                'ò': 'o',
                'ó': 'o',
                'ô': 'o',
                'õ': 'o',
                'ö': 'oe',
                'ő': 'o',
                'ø': 'o',
                'ù': 'u',
                'ú': 'u',
                'û': 'u',
                'ü': 'ue',
                'ű': 'u',
                'ý': 'y',
                'þ': 'th',
                'ÿ': 'y',
                'ẞ': 'SS',

                // language specific

                // Arabic
                'ا': 'a',
                'أ': 'a',
                'إ': 'i',
                'آ': 'aa',
                'ؤ': 'u',
                'ئ': 'e',
                'ء': 'a',
                'ب': 'b',
                'ت': 't',
                'ث': 'th',
                'ج': 'j',
                'ح': 'h',
                'خ': 'kh',
                'د': 'd',
                'ذ': 'th',
                'ر': 'r',
                'ز': 'z',
                'س': 's',
                'ش': 'sh',
                'ص': 's',
                'ض': 'dh',
                'ط': 't',
                'ظ': 'z',
                'ع': 'a',
                'غ': 'gh',
                'ف': 'f',
                'ق': 'q',
                'ك': 'k',
                'ل': 'l',
                'م': 'm',
                'ن': 'n',
                'ه': 'h',
                'و': 'w',
                'ي': 'y',
                'ى': 'a',
                'ة': 'h',
                'ﻻ': 'la',
                'ﻷ': 'laa',
                'ﻹ': 'lai',
                'ﻵ': 'laa',

                // Persian additional characters than Arabic
                'گ': 'g',
                'چ': 'ch',
                'پ': 'p',
                'ژ': 'zh',
                'ک': 'k',
                'ی': 'y',

                // Arabic diactrics
                'َ': 'a',
                'ً': 'an',
                'ِ': 'e',
                'ٍ': 'en',
                'ُ': 'u',
                'ٌ': 'on',
                'ْ': '',

                // Arabic numbers
                '٠': '0',
                '١': '1',
                '٢': '2',
                '٣': '3',
                '٤': '4',
                '٥': '5',
                '٦': '6',
                '٧': '7',
                '٨': '8',
                '٩': '9',

                // Persian numbers
                '۰': '0',
                '۱': '1',
                '۲': '2',
                '۳': '3',
                '۴': '4',
                '۵': '5',
                '۶': '6',
                '۷': '7',
                '۸': '8',
                '۹': '9',

                // Burmese consonants
                'က': 'k',
                'ခ': 'kh',
                'ဂ': 'g',
                'ဃ': 'ga',
                'င': 'ng',
                'စ': 's',
                'ဆ': 'sa',
                'ဇ': 'z',
                'စျ': 'za',
                'ည': 'ny',
                'ဋ': 't',
                'ဌ': 'ta',
                'ဍ': 'd',
                'ဎ': 'da',
                'ဏ': 'na',
                'တ': 't',
                'ထ': 'ta',
                'ဒ': 'd',
                'ဓ': 'da',
                'န': 'n',
                'ပ': 'p',
                'ဖ': 'pa',
                'ဗ': 'b',
                'ဘ': 'ba',
                'မ': 'm',
                'ယ': 'y',
                'ရ': 'ya',
                'လ': 'l',
                'ဝ': 'w',
                'သ': 'th',
                'ဟ': 'h',
                'ဠ': 'la',
                'အ': 'a',
                // consonant character combos
                'ြ': 'y',
                'ျ': 'ya',
                'ွ': 'w',
                'ြွ': 'yw',
                'ျွ': 'ywa',
                'ှ': 'h',
                // independent vowels
                'ဧ': 'e',
                '၏': '-e',
                'ဣ': 'i',
                'ဤ': '-i',
                'ဉ': 'u',
                'ဦ': '-u',
                'ဩ': 'aw',
                'သြော': 'aw',
                'ဪ': 'aw',
                // numbers
                '၀': '0',
                '၁': '1',
                '၂': '2',
                '၃': '3',
                '၄': '4',
                '၅': '5',
                '၆': '6',
                '၇': '7',
                '၈': '8',
                '၉': '9',
                // virama and tone marks which are silent in transliteration
                '္': '',
                '့': '',
                'း': '',

                // Czech
                'č': 'c',
                'ď': 'd',
                'ě': 'e',
                'ň': 'n',
                'ř': 'r',
                'š': 's',
                'ť': 't',
                'ů': 'u',
                'ž': 'z',
                'Č': 'C',
                'Ď': 'D',
                'Ě': 'E',
                'Ň': 'N',
                'Ř': 'R',
                'Š': 'S',
                'Ť': 'T',
                'Ů': 'U',
                'Ž': 'Z',

                // Dhivehi
                'ހ': 'h',
                'ށ': 'sh',
                'ނ': 'n',
                'ރ': 'r',
                'ބ': 'b',
                'ޅ': 'lh',
                'ކ': 'k',
                'އ': 'a',
                'ވ': 'v',
                'މ': 'm',
                'ފ': 'f',
                'ދ': 'dh',
                'ތ': 'th',
                'ލ': 'l',
                'ގ': 'g',
                'ޏ': 'gn',
                'ސ': 's',
                'ޑ': 'd',
                'ޒ': 'z',
                'ޓ': 't',
                'ޔ': 'y',
                'ޕ': 'p',
                'ޖ': 'j',
                'ޗ': 'ch',
                'ޘ': 'tt',
                'ޙ': 'hh',
                'ޚ': 'kh',
                'ޛ': 'th',
                'ޜ': 'z',
                'ޝ': 'sh',
                'ޞ': 's',
                'ޟ': 'd',
                'ޠ': 't',
                'ޡ': 'z',
                'ޢ': 'a',
                'ޣ': 'gh',
                'ޤ': 'q',
                'ޥ': 'w',
                'ަ': 'a',
                'ާ': 'aa',
                'ި': 'i',
                'ީ': 'ee',
                'ު': 'u',
                'ޫ': 'oo',
                'ެ': 'e',
                'ޭ': 'ey',
                'ޮ': 'o',
                'ޯ': 'oa',
                'ް': '',

                // Georgian https://en.wikipedia.org/wiki/Romanization_of_Georgian
                // National system (2002)
                'ა': 'a',
                'ბ': 'b',
                'გ': 'g',
                'დ': 'd',
                'ე': 'e',
                'ვ': 'v',
                'ზ': 'z',
                'თ': 't',
                'ი': 'i',
                'კ': 'k',
                'ლ': 'l',
                'მ': 'm',
                'ნ': 'n',
                'ო': 'o',
                'პ': 'p',
                'ჟ': 'zh',
                'რ': 'r',
                'ს': 's',
                'ტ': 't',
                'უ': 'u',
                'ფ': 'p',
                'ქ': 'k',
                'ღ': 'gh',
                'ყ': 'q',
                'შ': 'sh',
                'ჩ': 'ch',
                'ც': 'ts',
                'ძ': 'dz',
                'წ': 'ts',
                'ჭ': 'ch',
                'ხ': 'kh',
                'ჯ': 'j',
                'ჰ': 'h',

                // Greek
                'α': 'a',
                'β': 'v',
                'γ': 'g',
                'δ': 'd',
                'ε': 'e',
                'ζ': 'z',
                'η': 'i',
                'θ': 'th',
                'ι': 'i',
                'κ': 'k',
                'λ': 'l',
                'μ': 'm',
                'ν': 'n',
                'ξ': 'ks',
                'ο': 'o',
                'π': 'p',
                'ρ': 'r',
                'σ': 's',
                'τ': 't',
                'υ': 'y',
                'φ': 'f',
                'χ': 'x',
                'ψ': 'ps',
                'ω': 'o',
                'ά': 'a',
                'έ': 'e',
                'ί': 'i',
                'ό': 'o',
                'ύ': 'y',
                'ή': 'i',
                'ώ': 'o',
                'ς': 's',
                'ϊ': 'i',
                'ΰ': 'y',
                'ϋ': 'y',
                'ΐ': 'i',
                'Α': 'A',
                'Β': 'B',
                'Γ': 'G',
                'Δ': 'D',
                'Ε': 'E',
                'Ζ': 'Z',
                'Η': 'I',
                'Θ': 'TH',
                'Ι': 'I',
                'Κ': 'K',
                'Λ': 'L',
                'Μ': 'M',
                'Ν': 'N',
                'Ξ': 'KS',
                'Ο': 'O',
                'Π': 'P',
                'Ρ': 'R',
                'Σ': 'S',
                'Τ': 'T',
                'Υ': 'Y',
                'Φ': 'F',
                'Χ': 'X',
                'Ψ': 'PS',
                'Ω': 'O',
                'Ά': 'A',
                'Έ': 'E',
                'Ί': 'I',
                'Ό': 'O',
                'Ύ': 'Y',
                'Ή': 'I',
                'Ώ': 'O',
                'Ϊ': 'I',
                'Ϋ': 'Y',

                // Latvian
                'ā': 'a',
                // 'č': 'c', // duplicate
                'ē': 'e',
                'ģ': 'g',
                'ī': 'i',
                'ķ': 'k',
                'ļ': 'l',
                'ņ': 'n',
                // 'š': 's', // duplicate
                'ū': 'u',
                // 'ž': 'z', // duplicate
                'Ā': 'A',
                // 'Č': 'C', // duplicate
                'Ē': 'E',
                'Ģ': 'G',
                'Ī': 'I',
                'Ķ': 'k',
                'Ļ': 'L',
                'Ņ': 'N',
                // 'Š': 'S', // duplicate
                'Ū': 'U',
                // 'Ž': 'Z', // duplicate

                // Macedonian
                'Ќ': 'Kj',
                'ќ': 'kj',
                'Љ': 'Lj',
                'љ': 'lj',
                'Њ': 'Nj',
                'њ': 'nj',
                'Тс': 'Ts',
                'тс': 'ts',

                // Polish
                'ą': 'a',
                'ć': 'c',
                'ę': 'e',
                'ł': 'l',
                'ń': 'n',
                // 'ó': 'o', // duplicate
                'ś': 's',
                'ź': 'z',
                'ż': 'z',
                'Ą': 'A',
                'Ć': 'C',
                'Ę': 'E',
                'Ł': 'L',
                'Ń': 'N',
                'Ś': 'S',
                'Ź': 'Z',
                'Ż': 'Z',

                // Ukranian
                'Є': 'Ye',
                'І': 'I',
                'Ї': 'Yi',
                'Ґ': 'G',
                'є': 'ye',
                'і': 'i',
                'ї': 'yi',
                'ґ': 'g',

                // Romanian
                'ă': 'a',
                'Ă': 'A',
                'ș': 's',
                'Ș': 'S',
                // 'ş': 's', // duplicate
                // 'Ş': 'S', // duplicate
                'ț': 't',
                'Ț': 'T',
                'ţ': 't',
                'Ţ': 'T',

                // Russian https://en.wikipedia.org/wiki/Romanization_of_Russian
                // ICAO

                'а': 'a',
                'б': 'b',
                'в': 'v',
                'г': 'g',
                'д': 'd',
                'е': 'e',
                'ё': 'yo',
                'ж': 'zh',
                'з': 'z',
                'и': 'i',
                'й': 'i',
                'к': 'k',
                'л': 'l',
                'м': 'm',
                'н': 'n',
                'о': 'o',
                'п': 'p',
                'р': 'r',
                'с': 's',
                'т': 't',
                'у': 'u',
                'ф': 'f',
                'х': 'kh',
                'ц': 'c',
                'ч': 'ch',
                'ш': 'sh',
                'щ': 'sh',
                'ъ': '',
                'ы': 'y',
                'ь': '',
                'э': 'e',
                'ю': 'yu',
                'я': 'ya',
                'А': 'A',
                'Б': 'B',
                'В': 'V',
                'Г': 'G',
                'Д': 'D',
                'Е': 'E',
                'Ё': 'Yo',
                'Ж': 'Zh',
                'З': 'Z',
                'И': 'I',
                'Й': 'I',
                'К': 'K',
                'Л': 'L',
                'М': 'M',
                'Н': 'N',
                'О': 'O',
                'П': 'P',
                'Р': 'R',
                'С': 'S',
                'Т': 'T',
                'У': 'U',
                'Ф': 'F',
                'Х': 'Kh',
                'Ц': 'C',
                'Ч': 'Ch',
                'Ш': 'Sh',
                'Щ': 'Sh',
                'Ъ': '',
                'Ы': 'Y',
                'Ь': '',
                'Э': 'E',
                'Ю': 'Yu',
                'Я': 'Ya',

                // Serbian
                'ђ': 'dj',
                'ј': 'j',
                // 'љ': 'lj',  // duplicate
                // 'њ': 'nj', // duplicate
                'ћ': 'c',
                'џ': 'dz',
                'Ђ': 'Dj',
                'Ј': 'j',
                // 'Љ': 'Lj', // duplicate
                // 'Њ': 'Nj', // duplicate
                'Ћ': 'C',
                'Џ': 'Dz',

                // Slovak
                'ľ': 'l',
                'ĺ': 'l',
                'ŕ': 'r',
                'Ľ': 'L',
                'Ĺ': 'L',
                'Ŕ': 'R',

                // Turkish
                'ş': 's',
                'Ş': 'S',
                'ı': 'i',
                'İ': 'I',
                // 'ç': 'c', // duplicate
                // 'Ç': 'C', // duplicate
                // 'ü': 'u', // duplicate, see langCharMap
                // 'Ü': 'U', // duplicate, see langCharMap
                // 'ö': 'o', // duplicate, see langCharMap
                // 'Ö': 'O', // duplicate, see langCharMap
                'ğ': 'g',
                'Ğ': 'G',

                // Vietnamese
                'ả': 'a',
                'Ả': 'A',
                'ẳ': 'a',
                'Ẳ': 'A',
                'ẩ': 'a',
                'Ẩ': 'A',
                'đ': 'd',
                'Đ': 'D',
                'ẹ': 'e',
                'Ẹ': 'E',
                'ẽ': 'e',
                'Ẽ': 'E',
                'ẻ': 'e',
                'Ẻ': 'E',
                'ế': 'e',
                'Ế': 'E',
                'ề': 'e',
                'Ề': 'E',
                'ệ': 'e',
                'Ệ': 'E',
                'ễ': 'e',
                'Ễ': 'E',
                'ể': 'e',
                'Ể': 'E',
                'ỏ': 'o',
                'ọ': 'o',
                'Ọ': 'o',
                'ố': 'o',
                'Ố': 'O',
                'ồ': 'o',
                'Ồ': 'O',
                'ổ': 'o',
                'Ổ': 'O',
                'ộ': 'o',
                'Ộ': 'O',
                'ỗ': 'o',
                'Ỗ': 'O',
                'ơ': 'o',
                'Ơ': 'O',
                'ớ': 'o',
                'Ớ': 'O',
                'ờ': 'o',
                'Ờ': 'O',
                'ợ': 'o',
                'Ợ': 'O',
                'ỡ': 'o',
                'Ỡ': 'O',
                'Ở': 'o',
                'ở': 'o',
                'ị': 'i',
                'Ị': 'I',
                'ĩ': 'i',
                'Ĩ': 'I',
                'ỉ': 'i',
                'Ỉ': 'i',
                'ủ': 'u',
                'Ủ': 'U',
                'ụ': 'u',
                'Ụ': 'U',
                'ũ': 'u',
                'Ũ': 'U',
                'ư': 'u',
                'Ư': 'U',
                'ứ': 'u',
                'Ứ': 'U',
                'ừ': 'u',
                'Ừ': 'U',
                'ự': 'u',
                'Ự': 'U',
                'ữ': 'u',
                'Ữ': 'U',
                'ử': 'u',
                'Ử': 'ư',
                'ỷ': 'y',
                'Ỷ': 'y',
                'ỳ': 'y',
                'Ỳ': 'Y',
                'ỵ': 'y',
                'Ỵ': 'Y',
                'ỹ': 'y',
                'Ỹ': 'Y',
                'ạ': 'a',
                'Ạ': 'A',
                'ấ': 'a',
                'Ấ': 'A',
                'ầ': 'a',
                'Ầ': 'A',
                'ậ': 'a',
                'Ậ': 'A',
                'ẫ': 'a',
                'Ẫ': 'A',
                // 'ă': 'a', // duplicate
                // 'Ă': 'A', // duplicate
                'ắ': 'a',
                'Ắ': 'A',
                'ằ': 'a',
                'Ằ': 'A',
                'ặ': 'a',
                'Ặ': 'A',
                'ẵ': 'a',
                'Ẵ': 'A',
                "⓪": "0",
                "①": "1",
                "②": "2",
                "③": "3",
                "④": "4",
                "⑤": "5",
                "⑥": "6",
                "⑦": "7",
                "⑧": "8",
                "⑨": "9",
                "⑩": "10",
                "⑪": "11",
                "⑫": "12",
                "⑬": "13",
                "⑭": "14",
                "⑮": "15",
                "⑯": "16",
                "⑰": "17",
                "⑱": "18",
                "⑲": "18",
                "⑳": "18",

                "⓵": "1",
                "⓶": "2",
                "⓷": "3",
                "⓸": "4",
                "⓹": "5",
                "⓺": "6",
                "⓻": "7",
                "⓼": "8",
                "⓽": "9",
                "⓾": "10",

                "⓿": "0",
                "⓫": "11",
                "⓬": "12",
                "⓭": "13",
                "⓮": "14",
                "⓯": "15",
                "⓰": "16",
                "⓱": "17",
                "⓲": "18",
                "⓳": "19",
                "⓴": "20",

                "Ⓐ": "A",
                "Ⓑ": "B",
                "Ⓒ": "C",
                "Ⓓ": "D",
                "Ⓔ": "E",
                "Ⓕ": "F",
                "Ⓖ": "G",
                "Ⓗ": "H",
                "Ⓘ": "I",
                "Ⓙ": "J",
                "Ⓚ": "K",
                "Ⓛ": "L",
                "Ⓜ": "M",
                "Ⓝ": "N",
                "Ⓞ": "O",
                "Ⓟ": "P",
                "Ⓠ": "Q",
                "Ⓡ": "R",
                "Ⓢ": "S",
                "Ⓣ": "T",
                "Ⓤ": "U",
                "Ⓥ": "V",
                "Ⓦ": "W",
                "Ⓧ": "X",
                "Ⓨ": "Y",
                "Ⓩ": "Z",

                "ⓐ": "a",
                "ⓑ": "b",
                "ⓒ": "c",
                "ⓓ": "d",
                "ⓔ": "e",
                "ⓕ": "f",
                "ⓖ": "g",
                "ⓗ": "h",
                "ⓘ": "i",
                "ⓙ": "j",
                "ⓚ": "k",
                "ⓛ": "l",
                "ⓜ": "m",
                "ⓝ": "n",
                "ⓞ": "o",
                "ⓟ": "p",
                "ⓠ": "q",
                "ⓡ": "r",
                "ⓢ": "s",
                "ⓣ": "t",
                "ⓤ": "u",
                "ⓦ": "v",
                "ⓥ": "w",
                "ⓧ": "x",
                "ⓨ": "y",
                "ⓩ": "z",

                // symbols
                '“': '"',
                '”': '"',
                '‘': "'",
                '’': "'",
                '∂': 'd',
                'ƒ': 'f',
                '™': '(TM)',
                '©': '(C)',
                'œ': 'oe',
                'Œ': 'OE',
                '®': '(R)',
                '†': '+',
                '℠': '(SM)',
                '…': '...',
                '˚': 'o',
                'º': 'o',
                'ª': 'a',
                '•': '*',
                '၊': ',',
                '။': '.',

                // currency
                '$': 'USD',
                '€': 'EUR',
                '₢': 'BRN',
                '₣': 'FRF',
                '£': 'GBP',
                '₤': 'ITL',
                '₦': 'NGN',
                '₧': 'ESP',
                '₩': 'KRW',
                '₪': 'ILS',
                '₫': 'VND',
                '₭': 'LAK',
                '₮': 'MNT',
                '₯': 'GRD',
                '₱': 'ARS',
                '₲': 'PYG',
                '₳': 'ARA',
                '₴': 'UAH',
                '₵': 'GHS',
                '¢': 'cent',
                '¥': 'CNY',
                '元': 'CNY',
                '円': 'YEN',
                '﷼': 'IRR',
                '₠': 'EWE',
                '฿': 'THB',
                '₨': 'INR',
                '₹': 'INR',
                '₰': 'PF',
                '₺': 'TRY',
                '؋': 'AFN',
                '₼': 'AZN',
                'лв': 'BGN',
                '៛': 'KHR',
                '₡': 'CRC',
                '₸': 'KZT',
                'ден': 'MKD',
                'zł': 'PLN',
                '₽': 'RUB',
                '₾': 'GEL'

            };

            /**
             * special look ahead character array
             * These characters form with consonants to become 'single'/consonant combo
             * @type [Array]
             */
            var lookAheadCharArray = [
                // burmese
                '်',

                // Dhivehi
                'ް'
            ];

            /**
             * diatricMap for languages where transliteration changes entirely as more diatrics are added
             * @type {Object}
             */
            var diatricMap = {
                // Burmese
                // dependent vowels
                'ာ': 'a',
                'ါ': 'a',
                'ေ': 'e',
                'ဲ': 'e',
                'ိ': 'i',
                'ီ': 'i',
                'ို': 'o',
                'ု': 'u',
                'ူ': 'u',
                'ေါင်': 'aung',
                'ော': 'aw',
                'ော်': 'aw',
                'ေါ': 'aw',
                'ေါ်': 'aw',
                '်': '်', // this is special case but the character will be converted to latin in the code
                'က်': 'et',
                'ိုက်': 'aik',
                'ောက်': 'auk',
                'င်': 'in',
                'ိုင်': 'aing',
                'ောင်': 'aung',
                'စ်': 'it',
                'ည်': 'i',
                'တ်': 'at',
                'ိတ်': 'eik',
                'ုတ်': 'ok',
                'ွတ်': 'ut',
                'ေတ်': 'it',
                'ဒ်': 'd',
                'ိုဒ်': 'ok',
                'ုဒ်': 'ait',
                'န်': 'an',
                'ာန်': 'an',
                'ိန်': 'ein',
                'ုန်': 'on',
                'ွန်': 'un',
                'ပ်': 'at',
                'ိပ်': 'eik',
                'ုပ်': 'ok',
                'ွပ်': 'ut',
                'န်ုပ်': 'nub',
                'မ်': 'an',
                'ိမ်': 'ein',
                'ုမ်': 'on',
                'ွမ်': 'un',
                'ယ်': 'e',
                'ိုလ်': 'ol',
                'ဉ်': 'in',
                'ံ': 'an',
                'ိံ': 'ein',
                'ုံ': 'on',

                // Dhivehi
                'ައް': 'ah',
                'ަށް': 'ah'
            };

            /**
             * langCharMap language specific characters translations
             * @type   {Object}
             */
            var langCharMap = {
                'en': {}, // default language

                'az': { // Azerbaijani
                    'ç': 'c',
                    'ə': 'e',
                    'ğ': 'g',
                    'ı': 'i',
                    'ö': 'o',
                    'ş': 's',
                    'ü': 'u',
                    'Ç': 'C',
                    'Ə': 'E',
                    'Ğ': 'G',
                    'İ': 'I',
                    'Ö': 'O',
                    'Ş': 'S',
                    'Ü': 'U'
                },

                'cs': { // Czech
                    'č': 'c',
                    'ď': 'd',
                    'ě': 'e',
                    'ň': 'n',
                    'ř': 'r',
                    'š': 's',
                    'ť': 't',
                    'ů': 'u',
                    'ž': 'z',
                    'Č': 'C',
                    'Ď': 'D',
                    'Ě': 'E',
                    'Ň': 'N',
                    'Ř': 'R',
                    'Š': 'S',
                    'Ť': 'T',
                    'Ů': 'U',
                    'Ž': 'Z'
                },

                'fi': { // Finnish
                    // 'å': 'a', duplicate see charMap/latin
                    // 'Å': 'A', duplicate see charMap/latin
                    'ä': 'a', // ok
                    'Ä': 'A', // ok
                    'ö': 'o', // ok
                    'Ö': 'O' // ok
                },

                'hu': { // Hungarian
                    'ä': 'a', // ok
                    'Ä': 'A', // ok
                    // 'á': 'a', duplicate see charMap/latin
                    // 'Á': 'A', duplicate see charMap/latin
                    'ö': 'o', // ok
                    'Ö': 'O', // ok
                    // 'ő': 'o', duplicate see charMap/latin
                    // 'Ő': 'O', duplicate see charMap/latin
                    'ü': 'u',
                    'Ü': 'U',
                    'ű': 'u',
                    'Ű': 'U'
                },

                'lt': { // Lithuanian
                    'ą': 'a',
                    'č': 'c',
                    'ę': 'e',
                    'ė': 'e',
                    'į': 'i',
                    'š': 's',
                    'ų': 'u',
                    'ū': 'u',
                    'ž': 'z',
                    'Ą': 'A',
                    'Č': 'C',
                    'Ę': 'E',
                    'Ė': 'E',
                    'Į': 'I',
                    'Š': 'S',
                    'Ų': 'U',
                    'Ū': 'U'
                },

                'lv': { // Latvian
                    'ā': 'a',
                    'č': 'c',
                    'ē': 'e',
                    'ģ': 'g',
                    'ī': 'i',
                    'ķ': 'k',
                    'ļ': 'l',
                    'ņ': 'n',
                    'š': 's',
                    'ū': 'u',
                    'ž': 'z',
                    'Ā': 'A',
                    'Č': 'C',
                    'Ē': 'E',
                    'Ģ': 'G',
                    'Ī': 'i',
                    'Ķ': 'k',
                    'Ļ': 'L',
                    'Ņ': 'N',
                    'Š': 'S',
                    'Ū': 'u',
                    'Ž': 'Z'
                },

                'pl': { // Polish
                    'ą': 'a',
                    'ć': 'c',
                    'ę': 'e',
                    'ł': 'l',
                    'ń': 'n',
                    'ó': 'o',
                    'ś': 's',
                    'ź': 'z',
                    'ż': 'z',
                    'Ą': 'A',
                    'Ć': 'C',
                    'Ę': 'e',
                    'Ł': 'L',
                    'Ń': 'N',
                    'Ó': 'O',
                    'Ś': 'S',
                    'Ź': 'Z',
                    'Ż': 'Z'
                },

                'sv': { // Swedish
                    // 'å': 'a', duplicate see charMap/latin
                    // 'Å': 'A', duplicate see charMap/latin
                    'ä': 'a', // ok
                    'Ä': 'A', // ok
                    'ö': 'o', // ok
                    'Ö': 'O' // ok
                },

                'sk': { // Slovak
                    'ä': 'a',
                    'Ä': 'A'
                },

                'sr': { // Serbian
                    'љ': 'lj',
                    'њ': 'nj',
                    'Љ': 'Lj',
                    'Њ': 'Nj',
                    'đ': 'dj',
                    'Đ': 'Dj'
                },

                'tr': { // Turkish
                    'Ü': 'U',
                    'Ö': 'O',
                    'ü': 'u',
                    'ö': 'o'
                }
            };

            /**
             * symbolMap language specific symbol translations
             * translations must be transliterated already
             * @type   {Object}
             */
            var symbolMap = {
                'ar': {
                    '∆': 'delta',
                    '∞': 'la-nihaya',
                    '♥': 'hob',
                    '&': 'wa',
                    '|': 'aw',
                    '<': 'aqal-men',
                    '>': 'akbar-men',
                    '∑': 'majmou',
                    '¤': 'omla'
                },

                'az': {},

                'ca': {
                    '∆': 'delta',
                    '∞': 'infinit',
                    '♥': 'amor',
                    '&': 'i',
                    '|': 'o',
                    '<': 'menys que',
                    '>': 'mes que',
                    '∑': 'suma dels',
                    '¤': 'moneda'
                },

                'cs': {
                    '∆': 'delta',
                    '∞': 'nekonecno',
                    '♥': 'laska',
                    '&': 'a',
                    '|': 'nebo',
                    '<': 'mensi nez',
                    '>': 'vetsi nez',
                    '∑': 'soucet',
                    '¤': 'mena'
                },

                'de': {
                    '∆': 'delta',
                    '∞': 'unendlich',
                    '♥': 'Liebe',
                    '&': 'und',
                    '|': 'oder',
                    '<': 'kleiner als',
                    '>': 'groesser als',
                    '∑': 'Summe von',
                    '¤': 'Waehrung'
                },

                'dv': {
                    '∆': 'delta',
                    '∞': 'kolunulaa',
                    '♥': 'loabi',
                    '&': 'aai',
                    '|': 'noonee',
                    '<': 'ah vure kuda',
                    '>': 'ah vure bodu',
                    '∑': 'jumula',
                    '¤': 'faisaa'
                },

                'en': {
                    '∆': 'delta',
                    '∞': 'infinity',
                    '♥': 'love',
                    '&': 'and',
                    '|': 'or',
                    '<': 'less than',
                    '>': 'greater than',
                    '∑': 'sum',
                    '¤': 'currency'
                },

                'es': {
                    '∆': 'delta',
                    '∞': 'infinito',
                    '♥': 'amor',
                    '&': 'y',
                    '|': 'u',
                    '<': 'menos que',
                    '>': 'mas que',
                    '∑': 'suma de los',
                    '¤': 'moneda'
                },

                'fa': {
                    '∆': 'delta',
                    '∞': 'bi-nahayat',
                    '♥': 'eshgh',
                    '&': 'va',
                    '|': 'ya',
                    '<': 'kamtar-az',
                    '>': 'bishtar-az',
                    '∑': 'majmooe',
                    '¤': 'vahed'
                },

                'fi': {
                    '∆': 'delta',
                    '∞': 'aarettomyys',
                    '♥': 'rakkaus',
                    '&': 'ja',
                    '|': 'tai',
                    '<': 'pienempi kuin',
                    '>': 'suurempi kuin',
                    '∑': 'summa',
                    '¤': 'valuutta'
                },

                'fr': {
                    '∆': 'delta',
                    '∞': 'infiniment',
                    '♥': 'Amour',
                    '&': 'et',
                    '|': 'ou',
                    '<': 'moins que',
                    '>': 'superieure a',
                    '∑': 'somme des',
                    '¤': 'monnaie'
                },

                'ge': {
                    '∆': 'delta',
                    '∞': 'usasruloba',
                    '♥': 'siqvaruli',
                    '&': 'da',
                    '|': 'an',
                    '<': 'naklebi',
                    '>': 'meti',
                    '∑': 'jami',
                    '¤': 'valuta'
                },

                'gr': {},

                'hu': {
                    '∆': 'delta',
                    '∞': 'vegtelen',
                    '♥': 'szerelem',
                    '&': 'es',
                    '|': 'vagy',
                    '<': 'kisebb mint',
                    '>': 'nagyobb mint',
                    '∑': 'szumma',
                    '¤': 'penznem'
                },

                'it': {
                    '∆': 'delta',
                    '∞': 'infinito',
                    '♥': 'amore',
                    '&': 'e',
                    '|': 'o',
                    '<': 'minore di',
                    '>': 'maggiore di',
                    '∑': 'somma',
                    '¤': 'moneta'
                },

                'lt': {
                    '∆': 'delta',
                    '∞': 'begalybe',
                    '♥': 'meile',
                    '&': 'ir',
                    '|': 'ar',
                    '<': 'maziau nei',
                    '>': 'daugiau nei',
                    '∑': 'suma',
                    '¤': 'valiuta'
                },

                'lv': {
                    '∆': 'delta',
                    '∞': 'bezgaliba',
                    '♥': 'milestiba',
                    '&': 'un',
                    '|': 'vai',
                    '<': 'mazak neka',
                    '>': 'lielaks neka',
                    '∑': 'summa',
                    '¤': 'valuta'
                },

                'my': {
                    '∆': 'kwahkhyaet',
                    '∞': 'asaonasme',
                    '♥': 'akhyait',
                    '&': 'nhin',
                    '|': 'tho',
                    '<': 'ngethaw',
                    '>': 'kyithaw',
                    '∑': 'paungld',
                    '¤': 'ngwekye'
                },

                'mk': {},

                'nl': {
                    '∆': 'delta',
                    '∞': 'oneindig',
                    '♥': 'liefde',
                    '&': 'en',
                    '|': 'of',
                    '<': 'kleiner dan',
                    '>': 'groter dan',
                    '∑': 'som',
                    '¤': 'valuta'
                },

                'pl': {
                    '∆': 'delta',
                    '∞': 'nieskonczonosc',
                    '♥': 'milosc',
                    '&': 'i',
                    '|': 'lub',
                    '<': 'mniejsze niz',
                    '>': 'wieksze niz',
                    '∑': 'suma',
                    '¤': 'waluta'
                },

                'pt': {
                    '∆': 'delta',
                    '∞': 'infinito',
                    '♥': 'amor',
                    '&': 'e',
                    '|': 'ou',
                    '<': 'menor que',
                    '>': 'maior que',
                    '∑': 'soma',
                    '¤': 'moeda'
                },

                'ro': {
                    '∆': 'delta',
                    '∞': 'infinit',
                    '♥': 'dragoste',
                    '&': 'si',
                    '|': 'sau',
                    '<': 'mai mic ca',
                    '>': 'mai mare ca',
                    '∑': 'suma',
                    '¤': 'valuta'
                },

                'ru': {
                    '∆': 'delta',
                    '∞': 'beskonechno',
                    '♥': 'lubov',
                    '&': 'i',
                    '|': 'ili',
                    '<': 'menshe',
                    '>': 'bolshe',
                    '∑': 'summa',
                    '¤': 'valjuta'
                },

                'sk': {
                    '∆': 'delta',
                    '∞': 'nekonecno',
                    '♥': 'laska',
                    '&': 'a',
                    '|': 'alebo',
                    '<': 'menej ako',
                    '>': 'viac ako',
                    '∑': 'sucet',
                    '¤': 'mena'
                },

                'sr': {},

                'tr': {
                    '∆': 'delta',
                    '∞': 'sonsuzluk',
                    '♥': 'ask',
                    '&': 've',
                    '|': 'veya',
                    '<': 'kucuktur',
                    '>': 'buyuktur',
                    '∑': 'toplam',
                    '¤': 'para birimi'
                },

                'uk': {
                    '∆': 'delta',
                    '∞': 'bezkinechnist',
                    '♥': 'lubov',
                    '&': 'i',
                    '|': 'abo',
                    '<': 'menshe',
                    '>': 'bilshe',
                    '∑': 'suma',
                    '¤': 'valjuta'
                },

                'vn': {
                    '∆': 'delta',
                    '∞': 'vo cuc',
                    '♥': 'yeu',
                    '&': 'va',
                    '|': 'hoac',
                    '<': 'nho hon',
                    '>': 'lon hon',
                    '∑': 'tong',
                    '¤': 'tien te'
                }
            };

            var uricChars = [';', '?', ':', '@', '&', '=', '+', '$', ',', '/'].join('');

            var uricNoSlashChars = [';', '?', ':', '@', '&', '=', '+', '$', ','].join('');

            var markChars = ['.', '!', '~', '*', "'", '(', ')'].join('');

            /**
             * getSlug
             * @param  {string} input input string
             * @param  {object|string} opts config object or separator string/char
             * @api    public
             * @return {string}  sluggified string
             */
            var getSlug = function getSlug(input, opts) {
                var separator = '-';
                var result = '';
                var diatricString = '';
                var convertSymbols = true;
                var customReplacements = {};
                var maintainCase;
                var titleCase;
                var truncate;
                var uricFlag;
                var uricNoSlashFlag;
                var markFlag;
                var symbol;
                var langChar;
                var lucky;
                var i;
                var ch;
                var l;
                var lastCharWasSymbol;
                var lastCharWasDiatric;
                var allowedChars = '';

                if (typeof input !== 'string') {
                    return '';
                }

                if (typeof opts === 'string') {
                    separator = opts;
                }

                symbol = symbolMap.en;
                langChar = langCharMap.en;

                if (typeof opts === 'object') {
                    maintainCase = opts.maintainCase || false;
                    customReplacements = (opts.custom && typeof opts.custom === 'object') ? opts.custom : customReplacements;
                    truncate = (+opts.truncate > 1 && opts.truncate) || false;
                    uricFlag = opts.uric || false;
                    uricNoSlashFlag = opts.uricNoSlash || false;
                    markFlag = opts.mark || false;
                    convertSymbols = (opts.symbols === false || opts.lang === false) ? false : true;
                    separator = opts.separator || separator;

                    if (uricFlag) {
                        allowedChars += uricChars;
                    }

                    if (uricNoSlashFlag) {
                        allowedChars += uricNoSlashChars;
                    }

                    if (markFlag) {
                        allowedChars += markChars;
                    }

                    symbol = (opts.lang && symbolMap[opts.lang] && convertSymbols) ?
                        symbolMap[opts.lang] : (convertSymbols ? symbolMap.en : {});

                    langChar = (opts.lang && langCharMap[opts.lang]) ?
                        langCharMap[opts.lang] :
                        opts.lang === false || opts.lang === true ? {} : langCharMap.en;

                    // if titleCase config is an Array, rewrite to object format
                    if (opts.titleCase && typeof opts.titleCase.length === 'number' && Array.prototype.toString.call(opts.titleCase)) {
                        opts.titleCase.forEach(function (v) {
                            customReplacements[v + ''] = v + '';
                        });

                        titleCase = true;
                    } else {
                        titleCase = !!opts.titleCase;
                    }

                    // if custom config is an Array, rewrite to object format
                    if (opts.custom && typeof opts.custom.length === 'number' && Array.prototype.toString.call(opts.custom)) {
                        opts.custom.forEach(function (v) {
                            customReplacements[v + ''] = v + '';
                        });
                    }

                    // custom replacements
                    Object.keys(customReplacements).forEach(function (v) {
                        var r;

                        if (v.length > 1) {
                            r = new RegExp('\\b' + escapeChars(v) + '\\b', 'gi');
                        } else {
                            r = new RegExp(escapeChars(v), 'gi');
                        }

                        input = input.replace(r, customReplacements[v]);
                    });

                    // add all custom replacement to allowed charlist
                    for (ch in customReplacements) {
                        allowedChars += ch;
                    }
                }

                allowedChars += separator;

                // escape all necessary chars
                allowedChars = escapeChars(allowedChars);

                // trim whitespaces
                input = input.replace(/(^\s+|\s+$)/g, '');

                lastCharWasSymbol = false;
                lastCharWasDiatric = false;

                for (i = 0, l = input.length; i < l; i++) {
                    ch = input[i];

                    if (isReplacedCustomChar(ch, customReplacements)) {
                        // don't convert a already converted char
                        lastCharWasSymbol = false;
                    } else if (langChar[ch]) {
                        // process language specific diactrics chars conversion
                        ch = lastCharWasSymbol && langChar[ch].match(/[A-Za-z0-9]/) ? ' ' + langChar[ch] : langChar[ch];

                        lastCharWasSymbol = false;
                    } else if (ch in charMap) {
                        // the transliteration changes entirely when some special characters are added
                        if (i + 1 < l && lookAheadCharArray.indexOf(input[i + 1]) >= 0) {
                            diatricString += ch;
                            ch = '';
                        } else if (lastCharWasDiatric === true) {
                            ch = diatricMap[diatricString] + charMap[ch];
                            diatricString = '';
                        } else {
                            // process diactrics chars
                            ch = lastCharWasSymbol && charMap[ch].match(/[A-Za-z0-9]/) ? ' ' + charMap[ch] : charMap[ch];
                        }

                        lastCharWasSymbol = false;
                        lastCharWasDiatric = false;
                    } else if (ch in diatricMap) {
                        diatricString += ch;
                        ch = '';
                        // end of string, put the whole meaningful word
                        if (i === l - 1) {
                            ch = diatricMap[diatricString];
                        }
                        lastCharWasDiatric = true;
                    } else if (
                        // process symbol chars
                        symbol[ch] && !(uricFlag && uricChars
                            .indexOf(ch) !== -1) && !(uricNoSlashFlag && uricNoSlashChars
                        // .indexOf(ch) !== -1) && !(markFlag && markChars
                            .indexOf(ch) !== -1)) {
                        ch = lastCharWasSymbol || result.substr(-1).match(/[A-Za-z0-9]/) ? separator + symbol[ch] : symbol[ch];
                        ch += input[i + 1] !== void 0 && input[i + 1].match(/[A-Za-z0-9]/) ? separator : '';

                        lastCharWasSymbol = true;
                    } else {
                        if (lastCharWasDiatric === true) {
                            ch = diatricMap[diatricString] + ch;
                            diatricString = '';
                            lastCharWasDiatric = false;
                        } else if (lastCharWasSymbol && (/[A-Za-z0-9]/.test(ch) || result.substr(-1).match(/A-Za-z0-9]/))) {
                            // process latin chars
                            ch = ' ' + ch;
                        }
                        lastCharWasSymbol = false;
                    }

                    // add allowed chars
                    result += ch.replace(new RegExp('[^\\w\\s' + allowedChars + '_-]', 'g'), separator);
                }

                if (titleCase) {
                    result = result.replace(/(\w)(\S*)/g, function (_, i, r) {
                        var j = i.toUpperCase() + (r !== null ? r : '');
                        return (Object.keys(customReplacements).indexOf(j.toLowerCase()) < 0) ? j : j.toLowerCase();
                    });
                }

                // eliminate duplicate separators
                // add separator
                // trim separators from start and end
                result = result.replace(/\s+/g, separator)
                    .replace(new RegExp('\\' + separator + '+', 'g'), separator)
                    .replace(new RegExp('(^\\' + separator + '+|\\' + separator + '+$)', 'g'), '');

                if (truncate && result.length > truncate) {
                    lucky = result.charAt(truncate) === separator;
                    result = result.slice(0, truncate);

                    if (!lucky) {
                        result = result.slice(0, result.lastIndexOf(separator));
                    }
                }

                if (!maintainCase && !titleCase) {
                    result = result.toLowerCase();
                }

                return result;
            };

            /**
             * createSlug curried(opts)(input)
             * @param   {object|string} opts config object or input string
             * @return  {Function} function getSlugWithConfig()
             **/
            var createSlug = function createSlug(opts) {

                /**
                 * getSlugWithConfig
                 * @param   {string} input string
                 * @return  {string} slug string
                 */
                return function getSlugWithConfig(input) {
                    return getSlug(input, opts);
                };
            };

            /**
             * escape Chars
             * @param   {string} input string
             */
            var escapeChars = function escapeChars(input) {
                return input.replace(/[-\\^$*+?.()|[\]{}\/]/g, '\\$&');
            };

            /**
             * check if the char is an already converted char from custom list
             * @param   {char} ch character to check
             * @param   {object} customReplacements custom translation map
             */
            var isReplacedCustomChar = function (ch, customReplacements) {
                for (var c in customReplacements) {
                    if (customReplacements[c] === ch) {
                        return true;
                    }
                }
            };

            if ('object' !== 'undefined' && module.exports) {

                // export functions for use in Node
                module.exports = getSlug;
                module.exports.createSlug = createSlug;
            } else if (typeof undefined !== 'undefined' && undefined.amd) {

                // export function for use in AMD
                undefined([], function () {
                    return getSlug;
                });
            } else {

                // don't overwrite global if exists
                try {
                    if (root.getSlug || root.createSlug) {
                        throw 'speakingurl: globals exists /(getSlug|createSlug)/';
                    } else {
                        root.getSlug = getSlug;
                        root.createSlug = createSlug;
                    }
                } catch (e) {}
            }
        })(commonjsGlobal);
    });
    var speakingurl_1 = speakingurl.createSlug;

    var speakingurl$1 = speakingurl;

    var urlJoin = createCommonjsModule(function (module) {
        (function (name, context, definition) {
            if ('object' !== 'undefined' && module.exports) module.exports = definition();
            else if (typeof undefined === 'function' && undefined.amd) undefined(definition);
            else context[name] = definition();
        })('urljoin', commonjsGlobal, function () {

            function normalize (strArray) {
                var resultArray = [];
                if (strArray.length === 0) { return ''; }

                if (typeof strArray[0] !== 'string') {
                    throw new TypeError('Url must be a string. Received ' + strArray[0]);
                }

                // If the first part is a plain protocol, we combine it with the next part.
                if (strArray[0].match(/^[^/:]+:\/*$/) && strArray.length > 1) {
                    var first = strArray.shift();
                    strArray[0] = first + strArray[0];
                }

                // There must be two or three slashes in the file protocol, two slashes in anything else.
                if (strArray[0].match(/^file:\/\/\//)) {
                    strArray[0] = strArray[0].replace(/^([^/:]+):\/*/, '$1:///');
                } else {
                    strArray[0] = strArray[0].replace(/^([^/:]+):\/*/, '$1://');
                }

                for (var i = 0; i < strArray.length; i++) {
                    var component = strArray[i];

                    if (typeof component !== 'string') {
                        throw new TypeError('Url must be a string. Received ' + component);
                    }

                    if (component === '') { continue; }

                    if (i > 0) {
                        // Removing the starting slashes for each component but the first.
                        component = component.replace(/^[\/]+/, '');
                    }
                    if (i < strArray.length - 1) {
                        // Removing the ending slashes for each component but the last.
                        component = component.replace(/[\/]+$/, '');
                    } else {
                        // For the last component we will combine multiple slashes to a single one.
                        component = component.replace(/[\/]+$/, '/');
                    }

                    resultArray.push(component);

                }

                var str = resultArray.join('/');
                // Each input component is now separated by a single slash except the possible first plain protocol part.

                // remove trailing slash before parameters or hash
                str = str.replace(/\/(\?|&|#[^!])/g, '$1');

                // replace ? in parameters with &
                var parts = str.split('?');
                str = parts.shift() + (parts.length > 0 ? '?': '') + parts.join('&');

                return str;
            }

            return function () {
                var input;

                if (typeof arguments[0] === 'object') {
                    input = arguments[0];
                } else {
                    input = [].slice.call(arguments);
                }

                return normalize(input);
            };

        });
    });

    var uritemplate = createCommonjsModule(function (module) {
        /*global unescape, module, define, window, global*/

        /*
     UriTemplate Copyright (c) 2012-2013 Franz Antesberger. All Rights Reserved.
     Available via the MIT license.
    */

        (function (exportCallback) {
            "use strict";

            var UriTemplateError = (function () {

                function UriTemplateError (options) {
                    this.options = options;
                }

                UriTemplateError.prototype.toString = function () {
                    if (JSON && JSON.stringify) {
                        return JSON.stringify(this.options);
                    }
                    else {
                        return this.options;
                    }
                };

                return UriTemplateError;
            }());

            var objectHelper = (function () {
                function isArray (value) {
                    return Object.prototype.toString.apply(value) === '[object Array]';
                }

                function isString (value) {
                    return Object.prototype.toString.apply(value) === '[object String]';
                }

                function isNumber (value) {
                    return Object.prototype.toString.apply(value) === '[object Number]';
                }

                function isBoolean (value) {
                    return Object.prototype.toString.apply(value) === '[object Boolean]';
                }

                function join (arr, separator) {
                    var
                        result = '',
                        first = true,
                        index;
                    for (index = 0; index < arr.length; index += 1) {
                        if (first) {
                            first = false;
                        }
                        else {
                            result += separator;
                        }
                        result += arr[index];
                    }
                    return result;
                }

                function map (arr, mapper) {
                    var
                        result = [],
                        index = 0;
                    for (; index < arr.length; index += 1) {
                        result.push(mapper(arr[index]));
                    }
                    return result;
                }

                function filter (arr, predicate) {
                    var
                        result = [],
                        index = 0;
                    for (; index < arr.length; index += 1) {
                        if (predicate(arr[index])) {
                            result.push(arr[index]);
                        }
                    }
                    return result;
                }

                function deepFreezeUsingObjectFreeze (object) {
                    if (typeof object !== "object" || object === null) {
                        return object;
                    }
                    Object.freeze(object);
                    var property, propertyName;
                    for (propertyName in object) {
                        if (object.hasOwnProperty(propertyName)) {
                            property = object[propertyName];
                            // be aware, arrays are 'object', too
                            if (typeof property === "object") {
                                deepFreeze(property);
                            }
                        }
                    }
                    return object;
                }

                function deepFreeze (object) {
                    if (typeof Object.freeze === 'function') {
                        return deepFreezeUsingObjectFreeze(object);
                    }
                    return object;
                }


                return {
                    isArray: isArray,
                    isString: isString,
                    isNumber: isNumber,
                    isBoolean: isBoolean,
                    join: join,
                    map: map,
                    filter: filter,
                    deepFreeze: deepFreeze
                };
            }());

            var charHelper = (function () {

                function isAlpha (chr) {
                    return (chr >= 'a' && chr <= 'z') || ((chr >= 'A' && chr <= 'Z'));
                }

                function isDigit (chr) {
                    return chr >= '0' && chr <= '9';
                }

                function isHexDigit (chr) {
                    return isDigit(chr) || (chr >= 'a' && chr <= 'f') || (chr >= 'A' && chr <= 'F');
                }

                return {
                    isAlpha: isAlpha,
                    isDigit: isDigit,
                    isHexDigit: isHexDigit
                };
            }());

            var pctEncoder = (function () {
                var utf8 = {
                    encode: function (chr) {
                        // see http://ecmanaut.blogspot.de/2006/07/encoding-decoding-utf8-in-javascript.html
                        return unescape(encodeURIComponent(chr));
                    },
                    numBytes: function (firstCharCode) {
                        if (firstCharCode <= 0x7F) {
                            return 1;
                        }
                        else if (0xC2 <= firstCharCode && firstCharCode <= 0xDF) {
                            return 2;
                        }
                        else if (0xE0 <= firstCharCode && firstCharCode <= 0xEF) {
                            return 3;
                        }
                        else if (0xF0 <= firstCharCode && firstCharCode <= 0xF4) {
                            return 4;
                        }
                        // no valid first octet
                        return 0;
                    },
                    isValidFollowingCharCode: function (charCode) {
                        return 0x80 <= charCode && charCode <= 0xBF;
                    }
                };

                /**
                 * encodes a character, if needed or not.
                 * @param chr
                 * @return pct-encoded character
                 */
                function encodeCharacter (chr) {
                    var
                        result = '',
                        octets = utf8.encode(chr),
                        octet,
                        index;
                    for (index = 0; index < octets.length; index += 1) {
                        octet = octets.charCodeAt(index);
                        result += '%' + (octet < 0x10 ? '0' : '') + octet.toString(16).toUpperCase();
                    }
                    return result;
                }

                /**
                 * Returns, whether the given text at start is in the form 'percent hex-digit hex-digit', like '%3F'
                 * @param text
                 * @param start
                 * @return {boolean|*|*}
                 */
                function isPercentDigitDigit (text, start) {
                    return text.charAt(start) === '%' && charHelper.isHexDigit(text.charAt(start + 1)) && charHelper.isHexDigit(text.charAt(start + 2));
                }

                /**
                 * Parses a hex number from start with length 2.
                 * @param text a string
                 * @param start the start index of the 2-digit hex number
                 * @return {Number}
                 */
                function parseHex2 (text, start) {
                    return parseInt(text.substr(start, 2), 16);
                }

                /**
                 * Returns whether or not the given char sequence is a correctly pct-encoded sequence.
                 * @param chr
                 * @return {boolean}
                 */
                function isPctEncoded (chr) {
                    if (!isPercentDigitDigit(chr, 0)) {
                        return false;
                    }
                    var firstCharCode = parseHex2(chr, 1);
                    var numBytes = utf8.numBytes(firstCharCode);
                    if (numBytes === 0) {
                        return false;
                    }
                    for (var byteNumber = 1; byteNumber < numBytes; byteNumber += 1) {
                        if (!isPercentDigitDigit(chr, 3*byteNumber) || !utf8.isValidFollowingCharCode(parseHex2(chr, 3*byteNumber + 1))) {
                            return false;
                        }
                    }
                    return true;
                }

                /**
                 * Reads as much as needed from the text, e.g. '%20' or '%C3%B6'. It does not decode!
                 * @param text
                 * @param startIndex
                 * @return the character or pct-string of the text at startIndex
                 */
                function pctCharAt(text, startIndex) {
                    var chr = text.charAt(startIndex);
                    if (!isPercentDigitDigit(text, startIndex)) {
                        return chr;
                    }
                    var utf8CharCode = parseHex2(text, startIndex + 1);
                    var numBytes = utf8.numBytes(utf8CharCode);
                    if (numBytes === 0) {
                        return chr;
                    }
                    for (var byteNumber = 1; byteNumber < numBytes; byteNumber += 1) {
                        if (!isPercentDigitDigit(text, startIndex + 3 * byteNumber) || !utf8.isValidFollowingCharCode(parseHex2(text, startIndex + 3 * byteNumber + 1))) {
                            return chr;
                        }
                    }
                    return text.substr(startIndex, 3 * numBytes);
                }

                return {
                    encodeCharacter: encodeCharacter,
                    isPctEncoded: isPctEncoded,
                    pctCharAt: pctCharAt
                };
            }());

            var rfcCharHelper = (function () {

                /**
                 * Returns if an character is an varchar character according 2.3 of rfc 6570
                 * @param chr
                 * @return (Boolean)
                 */
                function isVarchar (chr) {
                    return charHelper.isAlpha(chr) || charHelper.isDigit(chr) || chr === '_' || pctEncoder.isPctEncoded(chr);
                }

                /**
                 * Returns if chr is an unreserved character according 1.5 of rfc 6570
                 * @param chr
                 * @return {Boolean}
                 */
                function isUnreserved (chr) {
                    return charHelper.isAlpha(chr) || charHelper.isDigit(chr) || chr === '-' || chr === '.' || chr === '_' || chr === '~';
                }

                /**
                 * Returns if chr is an reserved character according 1.5 of rfc 6570
                 * or the percent character mentioned in 3.2.1.
                 * @param chr
                 * @return {Boolean}
                 */
                function isReserved (chr) {
                    return chr === ':' || chr === '/' || chr === '?' || chr === '#' || chr === '[' || chr === ']' || chr === '@' || chr === '!' || chr === '$' || chr === '&' || chr === '(' ||
                        chr === ')' || chr === '*' || chr === '+' || chr === ',' || chr === ';' || chr === '=' || chr === "'";
                }

                return {
                    isVarchar: isVarchar,
                    isUnreserved: isUnreserved,
                    isReserved: isReserved
                };

            }());

            /**
             * encoding of rfc 6570
             */
            var encodingHelper = (function () {

                function encode (text, passReserved) {
                    var
                        result = '',
                        index,
                        chr = '';
                    if (typeof text === "number" || typeof text === "boolean") {
                        text = text.toString();
                    }
                    for (index = 0; index < text.length; index += chr.length) {
                        chr = text.charAt(index);
                        result += rfcCharHelper.isUnreserved(chr) || (passReserved && rfcCharHelper.isReserved(chr)) ? chr : pctEncoder.encodeCharacter(chr);
                    }
                    return result;
                }

                function encodePassReserved (text) {
                    return encode(text, true);
                }

                function encodeLiteralCharacter (literal, index) {
                    var chr = pctEncoder.pctCharAt(literal, index);
                    if (chr.length > 1) {
                        return chr;
                    }
                    else {
                        return rfcCharHelper.isReserved(chr) || rfcCharHelper.isUnreserved(chr) ? chr : pctEncoder.encodeCharacter(chr);
                    }
                }

                function encodeLiteral (literal) {
                    var
                        result = '',
                        index,
                        chr = '';
                    for (index = 0; index < literal.length; index += chr.length) {
                        chr = pctEncoder.pctCharAt(literal, index);
                        if (chr.length > 1) {
                            result += chr;
                        }
                        else {
                            result += rfcCharHelper.isReserved(chr) || rfcCharHelper.isUnreserved(chr) ? chr : pctEncoder.encodeCharacter(chr);
                        }
                    }
                    return result;
                }

                return {
                    encode: encode,
                    encodePassReserved: encodePassReserved,
                    encodeLiteral: encodeLiteral,
                    encodeLiteralCharacter: encodeLiteralCharacter
                };

            }());


            // the operators defined by rfc 6570
            var operators = (function () {

                var
                    bySymbol = {};

                function create (symbol) {
                    bySymbol[symbol] = {
                        symbol: symbol,
                        separator: (symbol === '?') ? '&' : (symbol === '' || symbol === '+' || symbol === '#') ? ',' : symbol,
                        named: symbol === ';' || symbol === '&' || symbol === '?',
                        ifEmpty: (symbol === '&' || symbol === '?') ? '=' : '',
                        first: (symbol === '+' ) ? '' : symbol,
                        encode: (symbol === '+' || symbol === '#') ? encodingHelper.encodePassReserved : encodingHelper.encode,
                        toString: function () {
                            return this.symbol;
                        }
                    };
                }

                create('');
                create('+');
                create('#');
                create('.');
                create('/');
                create(';');
                create('?');
                create('&');
                return {
                    valueOf: function (chr) {
                        if (bySymbol[chr]) {
                            return bySymbol[chr];
                        }
                        if ("=,!@|".indexOf(chr) >= 0) {
                            return null;
                        }
                        return bySymbol[''];
                    }
                };
            }());


            /**
             * Detects, whether a given element is defined in the sense of rfc 6570
             * Section 2.3 of the RFC makes clear defintions:
             * * undefined and null are not defined.
             * * the empty string is defined
             * * an array ("list") is defined, if it is not empty (even if all elements are not defined)
             * * an object ("map") is defined, if it contains at least one property with defined value
             * @param object
             * @return {Boolean}
             */
            function isDefined (object) {
                var
                    propertyName;
                if (object === null || object === undefined) {
                    return false;
                }
                if (objectHelper.isArray(object)) {
                    // Section 2.3: A variable defined as a list value is considered undefined if the list contains zero members
                    return object.length > 0;
                }
                if (typeof object === "string" || typeof object === "number" || typeof object === "boolean") {
                    // falsy values like empty strings, false or 0 are "defined"
                    return true;
                }
                // else Object
                for (propertyName in object) {
                    if (object.hasOwnProperty(propertyName) && isDefined(object[propertyName])) {
                        return true;
                    }
                }
                return false;
            }

            var LiteralExpression = (function () {
                function LiteralExpression (literal) {
                    this.literal = encodingHelper.encodeLiteral(literal);
                }

                LiteralExpression.prototype.expand = function () {
                    return this.literal;
                };

                LiteralExpression.prototype.toString = LiteralExpression.prototype.expand;

                return LiteralExpression;
            }());

            var parse = (function () {

                function parseExpression (expressionText) {
                    var
                        operator,
                        varspecs = [],
                        varspec = null,
                        varnameStart = null,
                        maxLengthStart = null,
                        index,
                        chr = '';

                    function closeVarname () {
                        var varname = expressionText.substring(varnameStart, index);
                        if (varname.length === 0) {
                            throw new UriTemplateError({expressionText: expressionText, message: "a varname must be specified", position: index});
                        }
                        varspec = {varname: varname, exploded: false, maxLength: null};
                        varnameStart = null;
                    }

                    function closeMaxLength () {
                        if (maxLengthStart === index) {
                            throw new UriTemplateError({expressionText: expressionText, message: "after a ':' you have to specify the length", position: index});
                        }
                        varspec.maxLength = parseInt(expressionText.substring(maxLengthStart, index), 10);
                        maxLengthStart = null;
                    }

                    operator = (function (operatorText) {
                        var op = operators.valueOf(operatorText);
                        if (op === null) {
                            throw new UriTemplateError({expressionText: expressionText, message: "illegal use of reserved operator", position: index, operator: operatorText});
                        }
                        return op;
                    }(expressionText.charAt(0)));
                    index = operator.symbol.length;

                    varnameStart = index;

                    for (; index < expressionText.length; index += chr.length) {
                        chr = pctEncoder.pctCharAt(expressionText, index);

                        if (varnameStart !== null) {
                            // the spec says: varname =  varchar *( ["."] varchar )
                            // so a dot is allowed except for the first char
                            if (chr === '.') {
                                if (varnameStart === index) {
                                    throw new UriTemplateError({expressionText: expressionText, message: "a varname MUST NOT start with a dot", position: index});
                                }
                                continue;
                            }
                            if (rfcCharHelper.isVarchar(chr)) {
                                continue;
                            }
                            closeVarname();
                        }
                        if (maxLengthStart !== null) {
                            if (index === maxLengthStart && chr === '0') {
                                throw new UriTemplateError({expressionText: expressionText, message: "A :prefix must not start with digit 0", position: index});
                            }
                            if (charHelper.isDigit(chr)) {
                                if (index - maxLengthStart >= 4) {
                                    throw new UriTemplateError({expressionText: expressionText, message: "A :prefix must have max 4 digits", position: index});
                                }
                                continue;
                            }
                            closeMaxLength();
                        }
                        if (chr === ':') {
                            if (varspec.maxLength !== null) {
                                throw new UriTemplateError({expressionText: expressionText, message: "only one :maxLength is allowed per varspec", position: index});
                            }
                            if (varspec.exploded) {
                                throw new UriTemplateError({expressionText: expressionText, message: "an exploeded varspec MUST NOT be varspeced", position: index});
                            }
                            maxLengthStart = index + 1;
                            continue;
                        }
                        if (chr === '*') {
                            if (varspec === null) {
                                throw new UriTemplateError({expressionText: expressionText, message: "exploded without varspec", position: index});
                            }
                            if (varspec.exploded) {
                                throw new UriTemplateError({expressionText: expressionText, message: "exploded twice", position: index});
                            }
                            if (varspec.maxLength) {
                                throw new UriTemplateError({expressionText: expressionText, message: "an explode (*) MUST NOT follow to a prefix", position: index});
                            }
                            varspec.exploded = true;
                            continue;
                        }
                        // the only legal character now is the comma
                        if (chr === ',') {
                            varspecs.push(varspec);
                            varspec = null;
                            varnameStart = index + 1;
                            continue;
                        }
                        throw new UriTemplateError({expressionText: expressionText, message: "illegal character", character: chr, position: index});
                    } // for chr
                    if (varnameStart !== null) {
                        closeVarname();
                    }
                    if (maxLengthStart !== null) {
                        closeMaxLength();
                    }
                    varspecs.push(varspec);
                    return new VariableExpression(expressionText, operator, varspecs);
                }

                function parse (uriTemplateText) {
                    // assert filled string
                    var
                        index,
                        chr,
                        expressions = [],
                        braceOpenIndex = null,
                        literalStart = 0;
                    for (index = 0; index < uriTemplateText.length; index += 1) {
                        chr = uriTemplateText.charAt(index);
                        if (literalStart !== null) {
                            if (chr === '}') {
                                throw new UriTemplateError({templateText: uriTemplateText, message: "unopened brace closed", position: index});
                            }
                            if (chr === '{') {
                        if (literalStart < index) {
                            expressions.push(new LiteralExpression(uriTemplateText.substring(literalStart, index)));
                        }
                        literalStart = null;
                        braceOpenIndex = index;
                    }
                    continue;
                }

                if (braceOpenIndex !== null) {
                    // here just { is forbidden
                    if (chr === '{') {
                        throw new UriTemplateError({templateText: uriTemplateText, message: "brace already opened", position: index});
                    }
                    if (chr === '}') {
                        if (braceOpenIndex + 1 === index) {
                            throw new UriTemplateError({templateText: uriTemplateText, message: "empty braces", position: braceOpenIndex});
                        }
                        try {
                            expressions.push(parseExpression(uriTemplateText.substring(braceOpenIndex + 1, index)));
                        }
                        catch (error) {
                            if (error.prototype === UriTemplateError.prototype) {
                                throw new UriTemplateError({templateText: uriTemplateText, message: error.options.message, position: braceOpenIndex + error.options.position, details: error.options});
                            }
                            throw error;
                        }
                        braceOpenIndex = null;
                        literalStart = index + 1;
                    }
                    continue;
                }
                throw new Error('reached unreachable code');
            }
            if (braceOpenIndex !== null) {
                throw new UriTemplateError({templateText: uriTemplateText, message: "unclosed brace", position: braceOpenIndex});
            }
            if (literalStart < uriTemplateText.length) {
                expressions.push(new LiteralExpression(uriTemplateText.substr(literalStart)));
            }
            return new UriTemplate(uriTemplateText, expressions);
        }

        return parse;
    }());

    var VariableExpression = (function () {
        // helper function if JSON is not available
        function prettyPrint (value) {
            return (JSON && JSON.stringify) ? JSON.stringify(value) : value;
        }

        function isEmpty (value) {
            if (!isDefined(value)) {
                return true;
            }
            if (objectHelper.isString(value)) {
                return value === '';
            }
            if (objectHelper.isNumber(value) || objectHelper.isBoolean(value)) {
                return false;
            }
            if (objectHelper.isArray(value)) {
                return value.length === 0;
            }
            for (var propertyName in value) {
                if (value.hasOwnProperty(propertyName)) {
                    return false;
                }
            }
            return true;
        }

        function propertyArray (object) {
            var
                result = [],
                propertyName;
            for (propertyName in object) {
                if (object.hasOwnProperty(propertyName)) {
                    result.push({name: propertyName, value: object[propertyName]});
                }
            }
            return result;
        }

        function VariableExpression (templateText, operator, varspecs) {
            this.templateText = templateText;
            this.operator = operator;
            this.varspecs = varspecs;
        }

        VariableExpression.prototype.toString = function () {
            return this.templateText;
        };

        function expandSimpleValue(varspec, operator, value) {
            var result = '';
            value = value.toString();
            if (operator.named) {
                result += encodingHelper.encodeLiteral(varspec.varname);
                if (value === '') {
                    result += operator.ifEmpty;
                    return result;
                }
                result += '=';
            }
            if (varspec.maxLength !== null) {
                value = value.substr(0, varspec.maxLength);
            }
            result += operator.encode(value);
            return result;
        }

        function valueDefined (nameValue) {
            return isDefined(nameValue.value);
        }

        function expandNotExploded(varspec, operator, value) {
            var
                arr = [],
                result = '';
            if (operator.named) {
                result += encodingHelper.encodeLiteral(varspec.varname);
                if (isEmpty(value)) {
                    result += operator.ifEmpty;
                    return result;
                }
                result += '=';
            }
            if (objectHelper.isArray(value)) {
                arr = value;
                arr = objectHelper.filter(arr, isDefined);
                arr = objectHelper.map(arr, operator.encode);
                result += objectHelper.join(arr, ',');
            }
            else {
                arr = propertyArray(value);
                arr = objectHelper.filter(arr, valueDefined);
                arr = objectHelper.map(arr, function (nameValue) {
                    return operator.encode(nameValue.name) + ',' + operator.encode(nameValue.value);
                });
                result += objectHelper.join(arr, ',');
            }
            return result;
        }

        function expandExplodedNamed (varspec, operator, value) {
            var
                isArray = objectHelper.isArray(value),
                arr = [];
            if (isArray) {
                arr = value;
                arr = objectHelper.filter(arr, isDefined);
                arr = objectHelper.map(arr, function (listElement) {
                    var tmp = encodingHelper.encodeLiteral(varspec.varname);
                    if (isEmpty(listElement)) {
                        tmp += operator.ifEmpty;
                    }
                    else {
                        tmp += '=' + operator.encode(listElement);
                    }
                    return tmp;
                });
            }
            else {
                arr = propertyArray(value);
                arr = objectHelper.filter(arr, valueDefined);
                arr = objectHelper.map(arr, function (nameValue) {
                    var tmp = encodingHelper.encodeLiteral(nameValue.name);
                    if (isEmpty(nameValue.value)) {
                        tmp += operator.ifEmpty;
                    }
                    else {
                        tmp += '=' + operator.encode(nameValue.value);
                    }
                    return tmp;
                });
            }
            return objectHelper.join(arr, operator.separator);
        }

        function expandExplodedUnnamed (operator, value) {
            var
                arr = [],
                result = '';
            if (objectHelper.isArray(value)) {
                arr = value;
                arr = objectHelper.filter(arr, isDefined);
                arr = objectHelper.map(arr, operator.encode);
                result += objectHelper.join(arr, operator.separator);
            }
            else {
                arr = propertyArray(value);
                arr = objectHelper.filter(arr, function (nameValue) {
                    return isDefined(nameValue.value);
                });
                arr = objectHelper.map(arr, function (nameValue) {
                    return operator.encode(nameValue.name) + '=' + operator.encode(nameValue.value);
                });
                result += objectHelper.join(arr, operator.separator);
            }
            return result;
        }


        VariableExpression.prototype.expand = function (variables) {
            var
                expanded = [],
                index,
                varspec,
                value,
                valueIsArr,
                oneExploded = false,
                operator = this.operator;

            // expand each varspec and join with operator's separator
                                    for (index = 0; index < this.varspecs.length; index += 1) {
                                    varspec = this.varspecs[index];
                                    value = variables[varspec.varname];
                                    // if (!isDefined(value)) {
                                    // if (variables.hasOwnProperty(varspec.name)) {
                                    if (value === null || value === undefined) {
                                    continue;
                                    }
                                if (varspec.exploded) {
                                    oneExploded = true;
                                }
                            valueIsArr = objectHelper.isArray(value);
                            if (typeof value === "string" || typeof value === "number" || typeof value === "boolean") {
                                expanded.push(expandSimpleValue(varspec, operator, value));
                            }
                            else if (varspec.maxLength && isDefined(value)) {
                                // 2.4.1 of the spec says: "Prefix modifiers are not applicable to variables that have composite values."
                                throw new Error('Prefix modifiers are not applicable to variables that have composite values. You tried to expand ' + this + " with " + prettyPrint(value));
                            }
                            else if (!varspec.exploded) {
                                if (operator.named || !isEmpty(value)) {
                                    expanded.push(expandNotExploded(varspec, operator, value));
                                }
                            }
                            else if (isDefined(value)) {
                                if (operator.named) {
                                    expanded.push(expandExplodedNamed(varspec, operator, value));
                                }
                                else {
                                    expanded.push(expandExplodedUnnamed(operator, value));
                                }
                            }
                        }

                        if (expanded.length === 0) {
                            return "";
                        }
                        else {
                            return operator.first + objectHelper.join(expanded, operator.separator);
                        }
                    };

                    return VariableExpression;
                }());

            var UriTemplate = (function () {
                function UriTemplate (templateText, expressions) {
                    this.templateText = templateText;
                    this.expressions = expressions;
                    objectHelper.deepFreeze(this);
                }

                UriTemplate.prototype.toString = function () {
                    return this.templateText;
                };

                UriTemplate.prototype.expand = function (variables) {
                    // this.expressions.map(function (expression) {return expression.expand(variables);}).join('');
                    var
                        index,
                        result = '';
                    for (index = 0; index < this.expressions.length; index += 1) {
                        result += this.expressions[index].expand(variables);
                    }
                    return result;
                };

                UriTemplate.parse = parse;
                UriTemplate.UriTemplateError = UriTemplateError;
                return UriTemplate;
            }());

            exportCallback(UriTemplate);

        }(function (UriTemplate) {
                "use strict";
                // export UriTemplate, when module is present, or pass it to window or global
                if ('object' !== "undefined") {
                    module.exports = UriTemplate;
                }
                else if (typeof undefined === "function") {
                    undefined([],function() {
                        return UriTemplate;
                    });
                }
                else if (typeof window !== "undefined") {
                    window.UriTemplate = UriTemplate;
                }
                else {
                    commonjsGlobal.UriTemplate = UriTemplate;
                }
            }
        ));
    });

    var store2 = createCommonjsModule(function (module) {
            /*! store2 - v2.10.0 - 2019-09-27
    * Copyright (c) 2019 Nathan Bubna; Licensed (MIT OR GPL-3.0) */
            ;(function(window, define) {
                var _ = {
                    version: "2.10.0",
                    areas: {},
                    apis: {},

                    // utilities
                    inherit: function(api, o) {
                        for (var p in api) {
                            if (!o.hasOwnProperty(p)) {
                                Object.defineProperty(o, p, Object.getOwnPropertyDescriptor(api, p));
                            }
                        }
                        return o;
                    },
                    stringify: function(d) {
                        return d === undefined || typeof d === "function" ? d+'' : JSON.stringify(d);
                    },
                    parse: function(s) {
                        // if it doesn't parse, return as is
                        try{ return JSON.parse(s); }catch(e){ return s; }
                    },

                    // extension hooks
                    fn: function(name, fn) {
                        _.storeAPI[name] = fn;
                        for (var api in _.apis) {
                            _.apis[api][name] = fn;
                        }
                    },
                    get: function(area, key){ return area.getItem(key); },
                    set: function(area, key, string){ area.setItem(key, string); },
                    remove: function(area, key){ area.removeItem(key); },
                    key: function(area, i){ return area.key(i); },
                    length: function(area){ return area.length; },
                    clear: function(area){ area.clear(); },

                    // core functions
                    Store: function(id, area, namespace) {
                        var store = _.inherit(_.storeAPI, function(key, data, overwrite) {
                            if (arguments.length === 0){ return store.getAll(); }
                            if (typeof data === "function"){ return store.transact(key, data, overwrite); }// fn=data, alt=overwrite
                            if (data !== undefined){ return store.set(key, data, overwrite); }
                            if (typeof key === "string" || typeof key === "number"){ return store.get(key); }
                            if (typeof key === "function"){ return store.each(key); }
                            if (!key){ return store.clear(); }
                            return store.setAll(key, data);// overwrite=data, data=key
                        });
                        store._id = id;
                        try {
                            var testKey = '_-bad-_';
                            area.setItem(testKey, 'wolf');
                            store._area = area;
                            area.removeItem(testKey);
                        } catch (e) {}
                        if (!store._area) {
                            store._area = _.storage('fake');
                        }
                        store._ns = namespace || '';
                        if (!_.areas[id]) {
                            _.areas[id] = store._area;
                        }
                        if (!_.apis[store._ns+store._id]) {
                            _.apis[store._ns+store._id] = store;
                        }
                        return store;
                    },
                    storeAPI: {
                        // admin functions
                        area: function(id, area) {
                            var store = this[id];
                            if (!store || !store.area) {
                                store = _.Store(id, area, this._ns);//new area-specific api in this namespace
                                if (!this[id]){ this[id] = store; }
                            }
                            return store;
                        },
                        namespace: function(namespace, singleArea) {
                            if (!namespace){
                                return this._ns ? this._ns.substring(0,this._ns.length-1) : '';
                            }
                            var ns = namespace, store = this[ns];
                            if (!store || !store.namespace) {
                                store = _.Store(this._id, this._area, this._ns+ns+'.');//new namespaced api
                                if (!this[ns]){ this[ns] = store; }
                                if (!singleArea) {
                                    for (var name in _.areas) {
                                        store.area(name, _.areas[name]);
                                    }
                                }
                            }
                            return store;
                        },
                        isFake: function(){ return this._area.name === 'fake'; },
                        toString: function() {
                            return 'store'+(this._ns?'.'+this.namespace():'')+'['+this._id+']';
                        },

                        // storage functions
                        has: function(key) {
                            if (this._area.has) {
                                return this._area.has(this._in(key));//extension hook
                            }
                            return !!(this._in(key) in this._area);
                        },
                        size: function(){ return this.keys().length; },
                        each: function(fn, fill) {// fill is used by keys(fillList) and getAll(fillList))
                    for (var i=0, m=_.length(this._area); i<m; i++) {
                        var key = this._out(_.key(this._area, i));
                        if (key !== undefined) {
                            if (fn.call(this, key, this.get(key), fill) === false) {
                                break;
                            }
                    }
                    if (m > _.length(this._area)) { m--; i--; }// in case of removeItem
            }
                return fill || this;
            },
                keys: function(fillList) {
                return this.each(function(k, v, list){ list.push(k); }, fillList || []);
            },
            get: function(key, alt) {
                var s = _.get(this._area, this._in(key));
                return s !== null ? _.parse(s) : alt || s;// support alt for easy default mgmt
            },
            getAll: function(fillObj) {
                return this.each(function(k, v, all){ all[k] = v; }, fillObj || {});
            },
            transact: function(key, fn, alt) {
                var val = this.get(key, alt),
                    ret = fn(val);
                this.set(key, ret === undefined ? val : ret);
                return this;
            },
            set: function(key, data, overwrite) {
                var d = this.get(key);
                if (d != null && overwrite === false) {
                    return data;
                }
                return _.set(this._area, this._in(key), _.stringify(data), overwrite) || d;
            },
            setAll: function(data, overwrite) {
                var changed, val;
                for (var key in data) {
                    val = data[key];
                    if (this.set(key, val, overwrite) !== val) {
                        changed = true;
                    }
                }
                return changed;
            },
            add: function(key, data) {
                var d = this.get(key);
                if (d instanceof Array) {
                    data = d.concat(data);
                } else if (d !== null) {
                    var type = typeof d;
                    if (type === typeof data && type === 'object') {
                        for (var k in data) {
                            d[k] = data[k];
                        }
                        data = d;
                    } else {
                        data = d + data;
                    }
                }
                _.set(this._area, this._in(key), _.stringify(data));
                return data;
            },
            remove: function(key, alt) {
                var d = this.get(key, alt);
                _.remove(this._area, this._in(key));
                return d;
            },
            clear: function() {
                if (!this._ns) {
                    _.clear(this._area);
                } else {
                    this.each(function(k){ _.remove(this._area, this._in(k)); }, 1);
                }
                return this;
            },
            clearAll: function() {
                var area = this._area;
                for (var id in _.areas) {
                    if (_.areas.hasOwnProperty(id)) {
                        this._area = _.areas[id];
                        this.clear();
                    }
                }
                this._area = area;
                return this;
            },

            // internal use functions
            _in: function(k) {
                if (typeof k !== "string"){ k = _.stringify(k); }
                return this._ns ? this._ns + k : k;
            },
            _out: function(k) {
                return this._ns ?
                    k && k.indexOf(this._ns) === 0 ?
                        k.substring(this._ns.length) :
                        undefined : // so each() knows to skip it
                    k;
            }
        },// end _.storeAPI
        storage: function(name) {
        return _.inherit(_.storageAPI, { items: {}, name: name });
    },
    storageAPI: {
        length: 0,
            has: function(k){ return this.items.hasOwnProperty(k); },
        key: function(i) {
            var c = 0;
            for (var k in this.items){
                if (this.has(k) && i === c++) {
                    return k;
                }
            }
        },
        setItem: function(k, v) {
            if (!this.has(k)) {
                this.length++;
            }
            this.items[k] = v;
        },
        removeItem: function(k) {
            if (this.has(k)) {
                delete this.items[k];
                this.length--;
            }
        },
        getItem: function(k){ return this.has(k) ? this.items[k] : null; },
        clear: function(){ for (var k in this.items){ this.removeItem(k); } }
    }// end _.storageAPI
    };

    var store =
        // safely set this up (throws error in IE10/32bit mode for local files)
        _.Store("local", (function(){try{ return localStorage; }catch(e){}})());
    store.local = store;// for completeness
    store._ = _;// for extenders and debuggers...
    // safely setup store.session (throws exception in FF for file:/// urls)
    store.area("session", (function(){try{ return sessionStorage; }catch(e){}})());
    store.area("page", _.storage("page"));

    if (typeof define === 'function' && define.amd !== undefined) {
        define('store2', [], function () {
            return store;
        });
    } else if ('object' !== 'undefined' && module.exports) {
        module.exports = store;
    } else {
        // expose the primary store fn to the global object and save conflicts
        if (window.store){ _.conflict = window.store; }
        window.store = store;
    }

    })(commonjsGlobal, commonjsGlobal && commonjsGlobal.define);
    });

    'use strict';

    var bind$1 = function bind(fn, thisArg) {
        return function wrap() {
            var args = new Array(arguments.length);
            for (var i = 0; i < args.length; i++) {
                args[i] = arguments[i];
            }
            return fn.apply(thisArg, args);
        };
    };

    /*!
     * Determine if an object is a Buffer
     *
     * @author   Feross Aboukhadijeh <https://feross.org>
     * @license  MIT
     */

    var isBuffer = function isBuffer (obj) {
        return obj != null && obj.constructor != null &&
            typeof obj.constructor.isBuffer === 'function' && obj.constructor.isBuffer(obj)
    };

    'use strict';




    /*global toString:true*/

    // utils is a library of generic helper functions non-specific to axios

    var toString = Object.prototype.toString;

    /**
     * Determine if a value is an Array
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is an Array, otherwise false
     */
    function isArray(val) {
        return toString.call(val) === '[object Array]';
    }

    /**
     * Determine if a value is an ArrayBuffer
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is an ArrayBuffer, otherwise false
     */
    function isArrayBuffer(val) {
        return toString.call(val) === '[object ArrayBuffer]';
    }

    /**
     * Determine if a value is a FormData
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is an FormData, otherwise false
     */
    function isFormData(val) {
        return (typeof FormData !== 'undefined') && (val instanceof FormData);
    }

    /**
     * Determine if a value is a view on an ArrayBuffer
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a view on an ArrayBuffer, otherwise false
     */
    function isArrayBufferView(val) {
        var result;
        if ((typeof ArrayBuffer !== 'undefined') && (ArrayBuffer.isView)) {
            result = ArrayBuffer.isView(val);
        } else {
            result = (val) && (val.buffer) && (val.buffer instanceof ArrayBuffer);
        }
        return result;
    }

    /**
     * Determine if a value is a String
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a String, otherwise false
     */
    function isString(val) {
        return typeof val === 'string';
    }

    /**
     * Determine if a value is a Number
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a Number, otherwise false
     */
    function isNumber(val) {
        return typeof val === 'number';
    }

    /**
     * Determine if a value is undefined
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if the value is undefined, otherwise false
     */
    function isUndefined(val) {
        return typeof val === 'undefined';
    }

    /**
     * Determine if a value is an Object
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is an Object, otherwise false
     */
    function isObject(val) {
        return val !== null && typeof val === 'object';
    }

    /**
     * Determine if a value is a Date
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a Date, otherwise false
     */
    function isDate(val) {
        return toString.call(val) === '[object Date]';
    }

    /**
     * Determine if a value is a File
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a File, otherwise false
     */
    function isFile(val) {
        return toString.call(val) === '[object File]';
    }

    /**
     * Determine if a value is a Blob
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a Blob, otherwise false
     */
    function isBlob(val) {
        return toString.call(val) === '[object Blob]';
    }

    /**
     * Determine if a value is a Function
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a Function, otherwise false
     */
    function isFunction(val) {
        return toString.call(val) === '[object Function]';
    }

    /**
     * Determine if a value is a Stream
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a Stream, otherwise false
     */
    function isStream(val) {
        return isObject(val) && isFunction(val.pipe);
    }

    /**
     * Determine if a value is a URLSearchParams object
     *
     * @param {Object} val The value to test
     * @returns {boolean} True if value is a URLSearchParams object, otherwise false
     */
    function isURLSearchParams(val) {
        return typeof URLSearchParams !== 'undefined' && val instanceof URLSearchParams;
    }

    /**
     * Trim excess whitespace off the beginning and end of a string
     *
     * @param {String} str The String to trim
     * @returns {String} The String freed of excess whitespace
     */
    function trim(str) {
        return str.replace(/^\s*/, '').replace(/\s*$/, '');
    }

    /**
     * Determine if we're running in a standard browser environment
     *
     * This allows axios to run in a web worker, and react-native.
     * Both environments support XMLHttpRequest, but not fully standard globals.
     *
     * web workers:
     *  typeof window -> undefined
     *  typeof document -> undefined
     *
     * react-native:
     *  navigator.product -> 'ReactNative'
     * nativescript
     *  navigator.product -> 'NativeScript' or 'NS'
     */
    function isStandardBrowserEnv() {
        if (typeof navigator !== 'undefined' && (navigator.product === 'ReactNative' ||
            navigator.product === 'NativeScript' ||
            navigator.product === 'NS')) {
            return false;
        }
        return (
            typeof window !== 'undefined' &&
            typeof document !== 'undefined'
        );
    }

    /**
     * Iterate over an Array or an Object invoking a function for each item.
     *
     * If `obj` is an Array callback will be called passing
     * the value, index, and complete array for each item.
     *
     * If 'obj' is an Object callback will be called passing
     * the value, key, and complete object for each property.
     *
     * @param {Object|Array} obj The object to iterate
     * @param {Function} fn The callback to invoke for each item
     */
    function forEach(obj, fn) {
        // Don't bother if no value provided
        if (obj === null || typeof obj === 'undefined') {
            return;
        }

        // Force an array if not already something iterable
        if (typeof obj !== 'object') {
            /*eslint no-param-reassign:0*/
            obj = [obj];
        }

        if (isArray(obj)) {
            // Iterate over array values
            for (var i = 0, l = obj.length; i < l; i++) {
                fn.call(null, obj[i], i, obj);
            }
        } else {
            // Iterate over object keys
            for (var key in obj) {
                if (Object.prototype.hasOwnProperty.call(obj, key)) {
                    fn.call(null, obj[key], key, obj);
                }
            }
        }
    }

    /**
     * Accepts varargs expecting each argument to be an object, then
     * immutably merges the properties of each object and returns result.
     *
     * When multiple objects contain the same key the later object in
     * the arguments list will take precedence.
     *
     * Example:
     *
     * ```js
     * var result = merge({foo: 123}, {foo: 456});
     * console.log(result.foo); // outputs 456
     * ```
     *
     * @param {Object} obj1 Object to merge
     * @returns {Object} Result of all merge properties
     */
    function merge(/* obj1, obj2, obj3, ... */) {
        var result = {};
        function assignValue(val, key) {
            if (typeof result[key] === 'object' && typeof val === 'object') {
                result[key] = merge(result[key], val);
            } else {
                result[key] = val;
            }
        }

        for (var i = 0, l = arguments.length; i < l; i++) {
            forEach(arguments[i], assignValue);
        }
        return result;
    }

    /**
     * Function equal to merge with the difference being that no reference
     * to original objects is kept.
     *
     * @see merge
     * @param {Object} obj1 Object to merge
     * @returns {Object} Result of all merge properties
     */
    function deepMerge(/* obj1, obj2, obj3, ... */) {
        var result = {};
        function assignValue(val, key) {
            if (typeof result[key] === 'object' && typeof val === 'object') {
                result[key] = deepMerge(result[key], val);
            } else if (typeof val === 'object') {
                result[key] = deepMerge({}, val);
            } else {
                result[key] = val;
            }
        }

        for (var i = 0, l = arguments.length; i < l; i++) {
            forEach(arguments[i], assignValue);
        }
        return result;
    }

    /**
     * Extends object a by mutably adding to it the properties of object b.
     *
     * @param {Object} a The object to be extended
     * @param {Object} b The object to copy properties from
     * @param {Object} thisArg The object to bind function to
     * @return {Object} The resulting value of object a
     */
    function extend(a, b, thisArg) {
        forEach(b, function assignValue(val, key) {
            if (thisArg && typeof val === 'function') {
                a[key] = bind$1(val, thisArg);
            } else {
                a[key] = val;
            }
        });
        return a;
    }

    var utils = {
        isArray: isArray,
        isArrayBuffer: isArrayBuffer,
        isBuffer: isBuffer,
        isFormData: isFormData,
        isArrayBufferView: isArrayBufferView,
        isString: isString,
        isNumber: isNumber,
        isObject: isObject,
        isUndefined: isUndefined,
        isDate: isDate,
        isFile: isFile,
        isBlob: isBlob,
        isFunction: isFunction,
        isStream: isStream,
        isURLSearchParams: isURLSearchParams,
        isStandardBrowserEnv: isStandardBrowserEnv,
        forEach: forEach,
        merge: merge,
        deepMerge: deepMerge,
        extend: extend,
        trim: trim
    };
    var utils_1 = utils.isArray;
    var utils_2 = utils.isArrayBuffer;
    var utils_3 = utils.isBuffer;
    var utils_4 = utils.isFormData;
    var utils_5 = utils.isArrayBufferView;
    var utils_6 = utils.isString;
    var utils_7 = utils.isNumber;
    var utils_8 = utils.isObject;
    var utils_9 = utils.isUndefined;
    var utils_10 = utils.isDate;
    var utils_11 = utils.isFile;
    var utils_12 = utils.isBlob;
    var utils_13 = utils.isFunction;
    var utils_14 = utils.isStream;
    var utils_15 = utils.isURLSearchParams;
    var utils_16 = utils.isStandardBrowserEnv;
    var utils_17 = utils.forEach;
    var utils_18 = utils.merge;
    var utils_19 = utils.deepMerge;
    var utils_20 = utils.extend;
    var utils_21 = utils.trim;

    'use strict';



    function encode$1(val) {
        return encodeURIComponent(val).
        replace(/%40/gi, '@').
        replace(/%3A/gi, ':').
        replace(/%24/g, '$').
        replace(/%2C/gi, ',').
        replace(/%20/g, '+').
        replace(/%5B/gi, '[').
        replace(/%5D/gi, ']');
    }

    /**
     * Build a URL by appending params to the end
     *
     * @param {string} url The base of the url (e.g., http://www.google.com)
     * @param {object} [params] The params to be appended
     * @returns {string} The formatted url
     */
    var buildURL = function buildURL(url, params, paramsSerializer) {
        /*eslint no-param-reassign:0*/
        if (!params) {
            return url;
        }

        var serializedParams;
        if (paramsSerializer) {
            serializedParams = paramsSerializer(params);
        } else if (utils.isURLSearchParams(params)) {
            serializedParams = params.toString();
        } else {
            var parts = [];

            utils.forEach(params, function serialize(val, key) {
                if (val === null || typeof val === 'undefined') {
                    return;
                }

                if (utils.isArray(val)) {
                    key = key + '[]';
                } else {
                    val = [val];
                }

                utils.forEach(val, function parseValue(v) {
                    if (utils.isDate(v)) {
                        v = v.toISOString();
                    } else if (utils.isObject(v)) {
                        v = JSON.stringify(v);
                    }
                    parts.push(encode$1(key) + '=' + encode$1(v));
                });
            });

            serializedParams = parts.join('&');
        }

        if (serializedParams) {
            var hashmarkIndex = url.indexOf('#');
            if (hashmarkIndex !== -1) {
                url = url.slice(0, hashmarkIndex);
            }

            url += (url.indexOf('?') === -1 ? '?' : '&') + serializedParams;
        }

        return url;
    };

    'use strict';



    function InterceptorManager() {
        this.handlers = [];
    }

    /**
     * Add a new interceptor to the stack
     *
     * @param {Function} fulfilled The function to handle `then` for a `Promise`
     * @param {Function} rejected The function to handle `reject` for a `Promise`
     *
     * @return {Number} An ID used to remove interceptor later
     */
    InterceptorManager.prototype.use = function use(fulfilled, rejected) {
        this.handlers.push({
            fulfilled: fulfilled,
            rejected: rejected
        });
        return this.handlers.length - 1;
    };

    /**
     * Remove an interceptor from the stack
     *
     * @param {Number} id The ID that was returned by `use`
     */
    InterceptorManager.prototype.eject = function eject(id) {
        if (this.handlers[id]) {
            this.handlers[id] = null;
        }
    };

    /**
     * Iterate over all the registered interceptors
     *
     * This method is particularly useful for skipping over any
     * interceptors that may have become `null` calling `eject`.
     *
     * @param {Function} fn The function to call for each interceptor
     */
    InterceptorManager.prototype.forEach = function forEach(fn) {
        utils.forEach(this.handlers, function forEachHandler(h) {
            if (h !== null) {
                fn(h);
            }
        });
    };

    var InterceptorManager_1 = InterceptorManager;

    'use strict';



    /**
     * Transform the data for a request or a response
     *
     * @param {Object|String} data The data to be transformed
     * @param {Array} headers The headers for the request or response
     * @param {Array|Function} fns A single function or Array of functions
     * @returns {*} The resulting transformed data
     */
    var transformData = function transformData(data, headers, fns) {
        /*eslint no-param-reassign:0*/
        utils.forEach(fns, function transform(fn) {
            data = fn(data, headers);
        });

        return data;
    };

    'use strict';

    var isCancel = function isCancel(value) {
        return !!(value && value.__CANCEL__);
    };

    'use strict';



    var normalizeHeaderName = function normalizeHeaderName(headers, normalizedName) {
        utils.forEach(headers, function processHeader(value, name) {
            if (name !== normalizedName && name.toUpperCase() === normalizedName.toUpperCase()) {
                headers[normalizedName] = value;
                delete headers[name];
            }
        });
    };

    'use strict';

    /**
     * Update an Error with the specified config, error code, and response.
     *
     * @param {Error} error The error to update.
     * @param {Object} config The config.
     * @param {string} [code] The error code (for example, 'ECONNABORTED').
     * @param {Object} [request] The request.
     * @param {Object} [response] The response.
     * @returns {Error} The error.
     */
    var enhanceError = function enhanceError(error, config, code, request, response) {
        error.config = config;
        if (code) {
            error.code = code;
        }

        error.request = request;
        error.response = response;
        error.isAxiosError = true;

        error.toJSON = function() {
            return {
                // Standard
                message: this.message,
                name: this.name,
                // Microsoft
                description: this.description,
                number: this.number,
                // Mozilla
                fileName: this.fileName,
                lineNumber: this.lineNumber,
                columnNumber: this.columnNumber,
                stack: this.stack,
                // Axios
                config: this.config,
                code: this.code
            };
        };
        return error;
    };

    'use strict';



    /**
     * Create an Error with the specified message, config, error code, request and response.
     *
     * @param {string} message The error message.
     * @param {Object} config The config.
     * @param {string} [code] The error code (for example, 'ECONNABORTED').
     * @param {Object} [request] The request.
     * @param {Object} [response] The response.
     * @returns {Error} The created error.
     */
    var createError = function createError(message, config, code, request, response) {
        var error = new Error(message);
        return enhanceError(error, config, code, request, response);
    };

    'use strict';



    /**
     * Resolve or reject a Promise based on response status.
     *
     * @param {Function} resolve A function that resolves the promise.
     * @param {Function} reject A function that rejects the promise.
     * @param {object} response The response.
     */
    var settle = function settle(resolve, reject, response) {
        var validateStatus = response.config.validateStatus;
        if (!validateStatus || validateStatus(response.status)) {
            resolve(response);
        } else {
            reject(createError(
                'Request failed with status code ' + response.status,
                response.config,
                null,
                response.request,
                response
            ));
        }
    };

    'use strict';



    // Headers whose duplicates are ignored by node
    // c.f. https://nodejs.org/api/http.html#http_message_headers
    var ignoreDuplicateOf = [
        'age', 'authorization', 'content-length', 'content-type', 'etag',
        'expires', 'from', 'host', 'if-modified-since', 'if-unmodified-since',
        'last-modified', 'location', 'max-forwards', 'proxy-authorization',
        'referer', 'retry-after', 'user-agent'
    ];

    /**
     * Parse headers into an object
     *
     * ```
     * Date: Wed, 27 Aug 2014 08:58:49 GMT
     * Content-Type: application/json
     * Connection: keep-alive
     * Transfer-Encoding: chunked
     * ```
     *
     * @param {String} headers Headers needing to be parsed
     * @returns {Object} Headers parsed into an object
     */
    var parseHeaders = function parseHeaders(headers) {
        var parsed = {};
        var key;
        var val;
        var i;

        if (!headers) { return parsed; }

        utils.forEach(headers.split('\n'), function parser(line) {
            i = line.indexOf(':');
            key = utils.trim(line.substr(0, i)).toLowerCase();
            val = utils.trim(line.substr(i + 1));

            if (key) {
                if (parsed[key] && ignoreDuplicateOf.indexOf(key) >= 0) {
                    return;
                }
                if (key === 'set-cookie') {
                    parsed[key] = (parsed[key] ? parsed[key] : []).concat([val]);
                } else {
                    parsed[key] = parsed[key] ? parsed[key] + ', ' + val : val;
                }
            }
        });

        return parsed;
    };

    'use strict';



    var isURLSameOrigin = (
        utils.isStandardBrowserEnv() ?

            // Standard browser envs have full support of the APIs needed to test
            // whether the request URL is of the same origin as current location.
            (function standardBrowserEnv() {
                var msie = /(msie|trident)/i.test(navigator.userAgent);
                var urlParsingNode = document.createElement('a');
                var originURL;

                /**
                 * Parse a URL to discover it's components
                 *
                 * @param {String} url The URL to be parsed
                 * @returns {Object}
                 */
                function resolveURL(url) {
                    var href = url;

                    if (msie) {
                        // IE needs attribute set twice to normalize properties
                        urlParsingNode.setAttribute('href', href);
                        href = urlParsingNode.href;
                    }

                    urlParsingNode.setAttribute('href', href);

                    // urlParsingNode provides the UrlUtils interface - http://url.spec.whatwg.org/#urlutils
                    return {
                        href: urlParsingNode.href,
                        protocol: urlParsingNode.protocol ? urlParsingNode.protocol.replace(/:$/, '') : '',
                        host: urlParsingNode.host,
                        search: urlParsingNode.search ? urlParsingNode.search.replace(/^\?/, '') : '',
                        hash: urlParsingNode.hash ? urlParsingNode.hash.replace(/^#/, '') : '',
                        hostname: urlParsingNode.hostname,
                        port: urlParsingNode.port,
                        pathname: (urlParsingNode.pathname.charAt(0) === '/') ?
                            urlParsingNode.pathname :
                            '/' + urlParsingNode.pathname
                    };
                }

                originURL = resolveURL(window.location.href);

                /**
                 * Determine if a URL shares the same origin as the current location
                 *
                 * @param {String} requestURL The URL to test
                 * @returns {boolean} True if URL shares the same origin, otherwise false
                 */
                return function isURLSameOrigin(requestURL) {
                    var parsed = (utils.isString(requestURL)) ? resolveURL(requestURL) : requestURL;
                    return (parsed.protocol === originURL.protocol &&
                        parsed.host === originURL.host);
                };
            })() :

            // Non standard browser envs (web workers, react-native) lack needed support.
            (function nonStandardBrowserEnv() {
                return function isURLSameOrigin() {
                    return true;
                };
            })()
    );

    'use strict';



    var cookies = (
        utils.isStandardBrowserEnv() ?

            // Standard browser envs support document.cookie
            (function standardBrowserEnv() {
                return {
                    write: function write(name, value, expires, path, domain, secure) {
                        var cookie = [];
                        cookie.push(name + '=' + encodeURIComponent(value));

                        if (utils.isNumber(expires)) {
                            cookie.push('expires=' + new Date(expires).toGMTString());
                        }

                        if (utils.isString(path)) {
                            cookie.push('path=' + path);
                        }

                        if (utils.isString(domain)) {
                            cookie.push('domain=' + domain);
                        }

                        if (secure === true) {
                            cookie.push('secure');
                        }

                        document.cookie = cookie.join('; ');
                    },

                    read: function read(name) {
                        var match = document.cookie.match(new RegExp('(^|;\\s*)(' + name + ')=([^;]*)'));
                        return (match ? decodeURIComponent(match[3]) : null);
                    },

                    remove: function remove(name) {
                        this.write(name, '', Date.now() - 86400000);
                    }
                };
            })() :

            // Non standard browser env (web workers, react-native) lack needed support.
            (function nonStandardBrowserEnv() {
                return {
                    write: function write() {},
                    read: function read() { return null; },
                    remove: function remove() {}
                };
            })()
    );

    'use strict';








    var xhr = function xhrAdapter(config) {
        return new Promise(function dispatchXhrRequest(resolve, reject) {
            var requestData = config.data;
            var requestHeaders = config.headers;

            if (utils.isFormData(requestData)) {
                delete requestHeaders['Content-Type']; // Let the browser set it
            }

            var request = new XMLHttpRequest();

            // HTTP basic authentication
            if (config.auth) {
                var username = config.auth.username || '';
                var password = config.auth.password || '';
                requestHeaders.Authorization = 'Basic ' + btoa(username + ':' + password);
            }

            request.open(config.method.toUpperCase(), buildURL(config.url, config.params, config.paramsSerializer), true);

            // Set the request timeout in MS
            request.timeout = config.timeout;

            // Listen for ready state
            request.onreadystatechange = function handleLoad() {
                if (!request || request.readyState !== 4) {
                    return;
                }

                // The request errored out and we didn't get a response, this will be
                // handled by onerror instead
                // With one exception: request that using file: protocol, most browsers
                // will return status as 0 even though it's a successful request
                if (request.status === 0 && !(request.responseURL && request.responseURL.indexOf('file:') === 0)) {
                    return;
                }

                // Prepare the response
                var responseHeaders = 'getAllResponseHeaders' in request ? parseHeaders(request.getAllResponseHeaders()) : null;
                var responseData = !config.responseType || config.responseType === 'text' ? request.responseText : request.response;
                var response = {
                    data: responseData,
                    status: request.status,
                    statusText: request.statusText,
                    headers: responseHeaders,
                    config: config,
                    request: request
                };

                settle(resolve, reject, response);

                // Clean up request
                request = null;
            };

            // Handle browser request cancellation (as opposed to a manual cancellation)
            request.onabort = function handleAbort() {
                if (!request) {
                    return;
                }

                reject(createError('Request aborted', config, 'ECONNABORTED', request));

                // Clean up request
                request = null;
            };

            // Handle low level network errors
            request.onerror = function handleError() {
                // Real errors are hidden from us by the browser
                // onerror should only fire if it's a network error
                reject(createError('Network Error', config, null, request));

                // Clean up request
                request = null;
            };

            // Handle timeout
            request.ontimeout = function handleTimeout() {
                reject(createError('timeout of ' + config.timeout + 'ms exceeded', config, 'ECONNABORTED',
                    request));

                // Clean up request
                request = null;
            };

            // Add xsrf header
            // This is only done if running in a standard browser environment.
            // Specifically not if we're in a web worker, or react-native.
            if (utils.isStandardBrowserEnv()) {
                var cookies$1 = cookies;

                // Add xsrf header
                var xsrfValue = (config.withCredentials || isURLSameOrigin(config.url)) && config.xsrfCookieName ?
                    cookies$1.read(config.xsrfCookieName) :
                    undefined;

                if (xsrfValue) {
                    requestHeaders[config.xsrfHeaderName] = xsrfValue;
                }
            }

            // Add headers to the request
            if ('setRequestHeader' in request) {
                utils.forEach(requestHeaders, function setRequestHeader(val, key) {
                    if (typeof requestData === 'undefined' && key.toLowerCase() === 'content-type') {
                        // Remove Content-Type if data is undefined
                        delete requestHeaders[key];
                    } else {
                        // Otherwise add header to the request
                        request.setRequestHeader(key, val);
                    }
                });
            }

            // Add withCredentials to request if needed
            if (config.withCredentials) {
                request.withCredentials = true;
            }

            // Add responseType to request if needed
            if (config.responseType) {
                try {
                    request.responseType = config.responseType;
                } catch (e) {
                    // Expected DOMException thrown by browsers not compatible XMLHttpRequest Level 2.
                    // But, this can be suppressed for 'json' type as it can be parsed by default 'transformResponse' function.
                    if (config.responseType !== 'json') {
                        throw e;
                    }
                }
            }

            // Handle progress if needed
            if (typeof config.onDownloadProgress === 'function') {
                request.addEventListener('progress', config.onDownloadProgress);
            }

            // Not all browsers support upload events
            if (typeof config.onUploadProgress === 'function' && request.upload) {
                request.upload.addEventListener('progress', config.onUploadProgress);
            }

            if (config.cancelToken) {
                // Handle cancellation
                config.cancelToken.promise.then(function onCanceled(cancel) {
                    if (!request) {
                        return;
                    }

                    request.abort();
                    reject(cancel);
                    // Clean up request
                    request = null;
                });
            }

            if (requestData === undefined) {
                requestData = null;
            }

            // Send the request
            request.send(requestData);
        });
    };

    'use strict';




    var DEFAULT_CONTENT_TYPE = {
        'Content-Type': 'application/x-www-form-urlencoded'
    };

    function setContentTypeIfUnset(headers, value) {
        if (!utils.isUndefined(headers) && utils.isUndefined(headers['Content-Type'])) {
            headers['Content-Type'] = value;
        }
    }

    function getDefaultAdapter() {
        var adapter;
        // Only Node.JS has a process variable that is of [[Class]] process
        if (typeof process !== 'undefined' && Object.prototype.toString.call(process) === '[object process]') {
            // For node use HTTP adapter
            adapter = xhr;
        } else if (typeof XMLHttpRequest !== 'undefined') {
            // For browsers use XHR adapter
            adapter = xhr;
        }
        return adapter;
    }

    var defaults = {
        adapter: getDefaultAdapter(),

        transformRequest: [function transformRequest(data, headers) {
            normalizeHeaderName(headers, 'Accept');
            normalizeHeaderName(headers, 'Content-Type');
            if (utils.isFormData(data) ||
                utils.isArrayBuffer(data) ||
                utils.isBuffer(data) ||
                utils.isStream(data) ||
                utils.isFile(data) ||
                utils.isBlob(data)
            ) {
                return data;
            }
            if (utils.isArrayBufferView(data)) {
                return data.buffer;
            }
            if (utils.isURLSearchParams(data)) {
                setContentTypeIfUnset(headers, 'application/x-www-form-urlencoded;charset=utf-8');
                return data.toString();
            }
            if (utils.isObject(data)) {
                setContentTypeIfUnset(headers, 'application/json;charset=utf-8');
                return JSON.stringify(data);
            }
            return data;
        }],

        transformResponse: [function transformResponse(data) {
            /*eslint no-param-reassign:0*/
            if (typeof data === 'string') {
                try {
                    data = JSON.parse(data);
                } catch (e) { /* Ignore */ }
            }
            return data;
        }],

        /**
         * A timeout in milliseconds to abort a request. If set to 0 (default) a
         * timeout is not created.
         */
        timeout: 0,

        xsrfCookieName: 'XSRF-TOKEN',
        xsrfHeaderName: 'X-XSRF-TOKEN',

        maxContentLength: -1,

        validateStatus: function validateStatus(status) {
            return status >= 200 && status < 300;
        }
    };

    defaults.headers = {
        common: {
            'Accept': 'application/json, text/plain, */*'
        }
    };

    utils.forEach(['delete', 'get', 'head'], function forEachMethodNoData(method) {
        defaults.headers[method] = {};
    });

    utils.forEach(['post', 'put', 'patch'], function forEachMethodWithData(method) {
        defaults.headers[method] = utils.merge(DEFAULT_CONTENT_TYPE);
    });

    var defaults_1 = defaults;

    'use strict';

    /**
     * Determines whether the specified URL is absolute
     *
     * @param {string} url The URL to test
     * @returns {boolean} True if the specified URL is absolute, otherwise false
     */
    var isAbsoluteURL = function isAbsoluteURL(url) {
        // A URL is considered absolute if it begins with "<scheme>://" or "//" (protocol-relative URL).
        // RFC 3986 defines scheme name as a sequence of characters beginning with a letter and followed
        // by any combination of letters, digits, plus, period, or hyphen.
        return /^([a-z][a-z\d\+\-\.]*:)?\/\//i.test(url);
    };

    'use strict';

    /**
     * Creates a new URL by combining the specified URLs
     *
     * @param {string} baseURL The base URL
     * @param {string} relativeURL The relative URL
     * @returns {string} The combined URL
     */
    var combineURLs = function combineURLs(baseURL, relativeURL) {
        return relativeURL
            ? baseURL.replace(/\/+$/, '') + '/' + relativeURL.replace(/^\/+/, '')
            : baseURL;
    };

    'use strict';








    /**
     * Throws a `Cancel` if cancellation has been requested.
     */
    function throwIfCancellationRequested(config) {
        if (config.cancelToken) {
            config.cancelToken.throwIfRequested();
        }
    }

    /**
     * Dispatch a request to the server using the configured adapter.
     *
     * @param {object} config The config that is to be used for the request
     * @returns {Promise} The Promise to be fulfilled
     */
    var dispatchRequest = function dispatchRequest(config) {
        throwIfCancellationRequested(config);

        // Support baseURL config
        if (config.baseURL && !isAbsoluteURL(config.url)) {
            config.url = combineURLs(config.baseURL, config.url);
        }

        // Ensure headers exist
        config.headers = config.headers || {};

        // Transform request data
        config.data = transformData(
            config.data,
            config.headers,
            config.transformRequest
        );

        // Flatten headers
        config.headers = utils.merge(
            config.headers.common || {},
            config.headers[config.method] || {},
            config.headers || {}
        );

        utils.forEach(
            ['delete', 'get', 'head', 'post', 'put', 'patch', 'common'],
            function cleanHeaderConfig(method) {
                delete config.headers[method];
            }
        );

        var adapter = config.adapter || defaults_1.adapter;

        return adapter(config).then(function onAdapterResolution(response) {
            throwIfCancellationRequested(config);

            // Transform response data
            response.data = transformData(
                response.data,
                response.headers,
                config.transformResponse
            );

            return response;
        }, function onAdapterRejection(reason) {
            if (!isCancel(reason)) {
                throwIfCancellationRequested(config);

                // Transform response data
                if (reason && reason.response) {
                    reason.response.data = transformData(
                        reason.response.data,
                        reason.response.headers,
                        config.transformResponse
                    );
                }
            }

            return Promise.reject(reason);
        });
    };

    'use strict';



    /**
     * Config-specific merge-function which creates a new config-object
     * by merging two configuration objects together.
     *
     * @param {Object} config1
     * @param {Object} config2
     * @returns {Object} New object resulting from merging config2 to config1
     */
    var mergeConfig = function mergeConfig(config1, config2) {
        // eslint-disable-next-line no-param-reassign
        config2 = config2 || {};
        var config = {};

        utils.forEach(['url', 'method', 'params', 'data'], function valueFromConfig2(prop) {
            if (typeof config2[prop] !== 'undefined') {
                config[prop] = config2[prop];
            }
        });

        utils.forEach(['headers', 'auth', 'proxy'], function mergeDeepProperties(prop) {
            if (utils.isObject(config2[prop])) {
                config[prop] = utils.deepMerge(config1[prop], config2[prop]);
            } else if (typeof config2[prop] !== 'undefined') {
                config[prop] = config2[prop];
            } else if (utils.isObject(config1[prop])) {
                config[prop] = utils.deepMerge(config1[prop]);
            } else if (typeof config1[prop] !== 'undefined') {
                config[prop] = config1[prop];
            }
        });

        utils.forEach([
            'baseURL', 'transformRequest', 'transformResponse', 'paramsSerializer',
            'timeout', 'withCredentials', 'adapter', 'responseType', 'xsrfCookieName',
            'xsrfHeaderName', 'onUploadProgress', 'onDownloadProgress', 'maxContentLength',
            'validateStatus', 'maxRedirects', 'httpAgent', 'httpsAgent', 'cancelToken',
            'socketPath'
        ], function defaultToConfig2(prop) {
            if (typeof config2[prop] !== 'undefined') {
                config[prop] = config2[prop];
            } else if (typeof config1[prop] !== 'undefined') {
                config[prop] = config1[prop];
            }
        });

        return config;
    };

    'use strict';







    /**
     * Create a new instance of Axios
     *
     * @param {Object} instanceConfig The default config for the instance
     */
    function Axios(instanceConfig) {
        this.defaults = instanceConfig;
        this.interceptors = {
            request: new InterceptorManager_1(),
            response: new InterceptorManager_1()
        };
    }

    /**
     * Dispatch a request
     *
     * @param {Object} config The config specific for this request (merged with this.defaults)
     */
    Axios.prototype.request = function request(config) {
        /*eslint no-param-reassign:0*/
        // Allow for axios('example/url'[, config]) a la fetch API
        if (typeof config === 'string') {
            config = arguments[1] || {};
            config.url = arguments[0];
        } else {
            config = config || {};
        }

        config = mergeConfig(this.defaults, config);
        config.method = config.method ? config.method.toLowerCase() : 'get';

        // Hook up interceptors middleware
        var chain = [dispatchRequest, undefined];
        var promise = Promise.resolve(config);

        this.interceptors.request.forEach(function unshiftRequestInterceptors(interceptor) {
            chain.unshift(interceptor.fulfilled, interceptor.rejected);
        });

        this.interceptors.response.forEach(function pushResponseInterceptors(interceptor) {
            chain.push(interceptor.fulfilled, interceptor.rejected);
        });

        while (chain.length) {
            promise = promise.then(chain.shift(), chain.shift());
        }

        return promise;
    };

    Axios.prototype.getUri = function getUri(config) {
        config = mergeConfig(this.defaults, config);
        return buildURL(config.url, config.params, config.paramsSerializer).replace(/^\?/, '');
    };

    // Provide aliases for supported request methods
    utils.forEach(['delete', 'get', 'head', 'options'], function forEachMethodNoData(method) {
        /*eslint func-names:0*/
        Axios.prototype[method] = function(url, config) {
            return this.request(utils.merge(config || {}, {
                method: method,
                url: url
            }));
        };
    });

    utils.forEach(['post', 'put', 'patch'], function forEachMethodWithData(method) {
        /*eslint func-names:0*/
        Axios.prototype[method] = function(url, data, config) {
            return this.request(utils.merge(config || {}, {
                method: method,
                url: url,
                data: data
            }));
        };
    });

    var Axios_1 = Axios;

    'use strict';

    /**
     * A `Cancel` is an object that is thrown when an operation is canceled.
     *
     * @class
     * @param {string=} message The message.
     */
    function Cancel(message) {
        this.message = message;
    }

    Cancel.prototype.toString = function toString() {
        return 'Cancel' + (this.message ? ': ' + this.message : '');
    };

    Cancel.prototype.__CANCEL__ = true;

    var Cancel_1 = Cancel;

    'use strict';



    /**
     * A `CancelToken` is an object that can be used to request cancellation of an operation.
     *
     * @class
     * @param {Function} executor The executor function.
     */
    function CancelToken(executor) {
        if (typeof executor !== 'function') {
            throw new TypeError('executor must be a function.');
        }

        var resolvePromise;
        this.promise = new Promise(function promiseExecutor(resolve) {
            resolvePromise = resolve;
        });

        var token = this;
        executor(function cancel(message) {
            if (token.reason) {
                // Cancellation has already been requested
                return;
            }

            token.reason = new Cancel_1(message);
            resolvePromise(token.reason);
        });
    }

    /**
     * Throws a `Cancel` if cancellation has been requested.
     */
    CancelToken.prototype.throwIfRequested = function throwIfRequested() {
        if (this.reason) {
            throw this.reason;
        }
    };

    /**
     * Returns an object that contains a new `CancelToken` and a function that, when called,
     * cancels the `CancelToken`.
     */
    CancelToken.source = function source() {
        var cancel;
        var token = new CancelToken(function executor(c) {
            cancel = c;
        });
        return {
            token: token,
            cancel: cancel
        };
    };

    var CancelToken_1 = CancelToken;

    'use strict';

    /**
     * Syntactic sugar for invoking a function and expanding an array for arguments.
     *
     * Common use case would be to use `Function.prototype.apply`.
     *
     *  ```js
     *  function f(x, y, z) {}
     *  var args = [1, 2, 3];
     *  f.apply(null, args);
     *  ```
     *
     * With `spread` this example can be re-written.
     *
     *  ```js
     *  spread(function(x, y, z) {})([1, 2, 3]);
     *  ```
     *
     * @param {Function} callback
     * @returns {Function}
     */
    var spread$1 = function spread(callback) {
        return function wrap(arr) {
            return callback.apply(null, arr);
        };
    };

    'use strict';







    /**
     * Create an instance of Axios
     *
     * @param {Object} defaultConfig The default config for the instance
     * @return {Axios} A new instance of Axios
     */
    function createInstance(defaultConfig) {
        var context = new Axios_1(defaultConfig);
        var instance = bind$1(Axios_1.prototype.request, context);

        // Copy axios.prototype to instance
        utils.extend(instance, Axios_1.prototype, context);

        // Copy context to instance
        utils.extend(instance, context);

        return instance;
    }

    // Create the default instance to be exported
    var axios = createInstance(defaults_1);

    // Expose Axios class to allow class inheritance
    axios.Axios = Axios_1;

    // Factory for creating new instances
    axios.create = function create(instanceConfig) {
        return createInstance(mergeConfig(axios.defaults, instanceConfig));
    };

    // Expose Cancel & CancelToken
    axios.Cancel = Cancel_1;
    axios.CancelToken = CancelToken_1;
    axios.isCancel = isCancel;

    // Expose all/spread
    axios.all = function all(promises) {
        return Promise.all(promises);
    };
    axios.spread = spread$1;

    var axios_1 = axios;

    // Allow use of default import syntax in TypeScript
    var default_1 = axios;
    axios_1.default = default_1;

    var axios$1 = axios_1;

    'use strict';

    var has$1 = Object.prototype.hasOwnProperty;
    var isArray$1 = Array.isArray;

    var hexTable = (function () {
        var array = [];
        for (var i = 0; i < 256; ++i) {
            array.push('%' + ((i < 16 ? '0' : '') + i.toString(16)).toUpperCase());
        }

        return array;
    }());

    var compactQueue = function compactQueue(queue) {
        while (queue.length > 1) {
            var item = queue.pop();
            var obj = item.obj[item.prop];

            if (isArray$1(obj)) {
                var compacted = [];

                for (var j = 0; j < obj.length; ++j) {
                    if (typeof obj[j] !== 'undefined') {
                        compacted.push(obj[j]);
                    }
                }

                item.obj[item.prop] = compacted;
            }
        }
    };

    var arrayToObject = function arrayToObject(source, options) {
        var obj = options && options.plainObjects ? Object.create(null) : {};
        for (var i = 0; i < source.length; ++i) {
            if (typeof source[i] !== 'undefined') {
                obj[i] = source[i];
            }
        }

        return obj;
    };

    var merge$1 = function merge(target, source, options) {
        /* eslint no-param-reassign: 0 */
        if (!source) {
            return target;
        }

        if (typeof source !== 'object') {
            if (isArray$1(target)) {
                target.push(source);
            } else if (target && typeof target === 'object') {
                if ((options && (options.plainObjects || options.allowPrototypes)) || !has$1.call(Object.prototype, source)) {
                    target[source] = true;
                }
            } else {
                return [target, source];
            }

            return target;
        }

        if (!target || typeof target !== 'object') {
            return [target].concat(source);
        }

        var mergeTarget = target;
        if (isArray$1(target) && !isArray$1(source)) {
            mergeTarget = arrayToObject(target, options);
        }

        if (isArray$1(target) && isArray$1(source)) {
            source.forEach(function (item, i) {
                if (has$1.call(target, i)) {
                    var targetItem = target[i];
                    if (targetItem && typeof targetItem === 'object' && item && typeof item === 'object') {
                        target[i] = merge(targetItem, item, options);
                    } else {
                        target.push(item);
                    }
                } else {
                    target[i] = item;
                }
            });
            return target;
        }

        return Object.keys(source).reduce(function (acc, key) {
            var value = source[key];

            if (has$1.call(acc, key)) {
                acc[key] = merge(acc[key], value, options);
            } else {
                acc[key] = value;
            }
            return acc;
        }, mergeTarget);
    };

    var assign$1 = function assignSingleSource(target, source) {
        return Object.keys(source).reduce(function (acc, key) {
            acc[key] = source[key];
            return acc;
        }, target);
    };

    var decode$1 = function (str, decoder, charset) {
        var strWithoutPlus = str.replace(/\+/g, ' ');
        if (charset === 'iso-8859-1') {
            // unescape never throws, no try...catch needed:
            return strWithoutPlus.replace(/%[0-9a-f]{2}/gi, unescape);
        }
        // utf-8
        try {
            return decodeURIComponent(strWithoutPlus);
        } catch (e) {
            return strWithoutPlus;
        }
    };

    var encode$2 = function encode(str, defaultEncoder, charset) {
        // This code was originally written by Brian White (mscdex) for the io.js core querystring library.
        // It has been adapted here for stricter adherence to RFC 3986
        if (str.length === 0) {
            return str;
        }

        var string = str;
        if (typeof str === 'symbol') {
            string = Symbol.prototype.toString.call(str);
        } else if (typeof str !== 'string') {
            string = String(str);
        }

        if (charset === 'iso-8859-1') {
            return escape(string).replace(/%u[0-9a-f]{4}/gi, function ($0) {
                return '%26%23' + parseInt($0.slice(2), 16) + '%3B';
            });
        }

        var out = '';
        for (var i = 0; i < string.length; ++i) {
            var c = string.charCodeAt(i);

            if (
                c === 0x2D // -
                || c === 0x2E // .
                || c === 0x5F // _
                || c === 0x7E // ~
                || (c >= 0x30 && c <= 0x39) // 0-9
                || (c >= 0x41 && c <= 0x5A) // a-z
                || (c >= 0x61 && c <= 0x7A) // A-Z
            ) {
                out += string.charAt(i);
                continue;
            }

            if (c < 0x80) {
                out = out + hexTable[c];
                continue;
            }

            if (c < 0x800) {
                out = out + (hexTable[0xC0 | (c >> 6)] + hexTable[0x80 | (c & 0x3F)]);
                continue;
            }

            if (c < 0xD800 || c >= 0xE000) {
                out = out + (hexTable[0xE0 | (c >> 12)] + hexTable[0x80 | ((c >> 6) & 0x3F)] + hexTable[0x80 | (c & 0x3F)]);
                continue;
            }

            i += 1;
            c = 0x10000 + (((c & 0x3FF) << 10) | (string.charCodeAt(i) & 0x3FF));
            out += hexTable[0xF0 | (c >> 18)]
                + hexTable[0x80 | ((c >> 12) & 0x3F)]
                + hexTable[0x80 | ((c >> 6) & 0x3F)]
                + hexTable[0x80 | (c & 0x3F)];
        }

        return out;
    };

    var compact = function compact(value) {
        var queue = [{ obj: { o: value }, prop: 'o' }];
        var refs = [];

        for (var i = 0; i < queue.length; ++i) {
            var item = queue[i];
            var obj = item.obj[item.prop];

            var keys = Object.keys(obj);
            for (var j = 0; j < keys.length; ++j) {
                var key = keys[j];
                var val = obj[key];
                if (typeof val === 'object' && val !== null && refs.indexOf(val) === -1) {
                    queue.push({ obj: obj, prop: key });
                    refs.push(val);
                }
            }
        }

        compactQueue(queue);

        return value;
    };

    var isRegExp = function isRegExp(obj) {
        return Object.prototype.toString.call(obj) === '[object RegExp]';
    };

    var isBuffer$1 = function isBuffer(obj) {
        if (!obj || typeof obj !== 'object') {
            return false;
        }

        return !!(obj.constructor && obj.constructor.isBuffer && obj.constructor.isBuffer(obj));
    };

    var combine = function combine(a, b) {
        return [].concat(a, b);
    };

    var utils$1 = {
        arrayToObject: arrayToObject,
        assign: assign$1,
        combine: combine,
        compact: compact,
        decode: decode$1,
        encode: encode$2,
        isBuffer: isBuffer$1,
        isRegExp: isRegExp,
        merge: merge$1
    };
    var utils_1$1 = utils$1.arrayToObject;
    var utils_2$1 = utils$1.assign;
    var utils_3$1 = utils$1.combine;
    var utils_4$1 = utils$1.compact;
    var utils_5$1 = utils$1.decode;
    var utils_6$1 = utils$1.encode;
    var utils_7$1 = utils$1.isBuffer;
    var utils_8$1 = utils$1.isRegExp;
    var utils_9$1 = utils$1.merge;

    'use strict';

    var replace = String.prototype.replace;
    var percentTwenties = /%20/g;



    var Format = {
        RFC1738: 'RFC1738',
        RFC3986: 'RFC3986'
    };

    var formats = utils$1.assign(
        {
            'default': Format.RFC3986,
            formatters: {
                RFC1738: function (value) {
                    return replace.call(value, percentTwenties, '+');
                },
                RFC3986: function (value) {
                    return String(value);
                }
            }
        },
        Format
    );

    'use strict';



    var has$2 = Object.prototype.hasOwnProperty;

    var arrayPrefixGenerators = {
        brackets: function brackets(prefix) {
            return prefix + '[]';
        },
        comma: 'comma',
        indices: function indices(prefix, key) {
            return prefix + '[' + key + ']';
        },
        repeat: function repeat(prefix) {
            return prefix;
        }
    };

    var isArray$2 = Array.isArray;
    var push = Array.prototype.push;
    var pushToArray = function (arr, valueOrArray) {
        push.apply(arr, isArray$2(valueOrArray) ? valueOrArray : [valueOrArray]);
    };

    var toISO = Date.prototype.toISOString;

    var defaultFormat = formats['default'];
    var defaults$1 = {
        addQueryPrefix: false,
        allowDots: false,
        charset: 'utf-8',
        charsetSentinel: false,
        delimiter: '&',
        encode: true,
        encoder: utils$1.encode,
        encodeValuesOnly: false,
        format: defaultFormat,
        formatter: formats.formatters[defaultFormat],
        // deprecated
        indices: false,
        serializeDate: function serializeDate(date) {
            return toISO.call(date);
        },
        skipNulls: false,
        strictNullHandling: false
    };

    var isNonNullishPrimitive = function isNonNullishPrimitive(v) {
        return typeof v === 'string'
            || typeof v === 'number'
            || typeof v === 'boolean'
            || typeof v === 'symbol'
            || typeof v === 'bigint';
    };

    var stringify$1 = function stringify(
        object,
        prefix,
        generateArrayPrefix,
        strictNullHandling,
        skipNulls,
        encoder,
        filter,
        sort,
        allowDots,
        serializeDate,
        formatter,
        encodeValuesOnly,
        charset
    ) {
        var obj = object;
        if (typeof filter === 'function') {
            obj = filter(prefix, obj);
        } else if (obj instanceof Date) {
            obj = serializeDate(obj);
        } else if (generateArrayPrefix === 'comma' && isArray$2(obj)) {
            obj = obj.join(',');
        }

        if (obj === null) {
            if (strictNullHandling) {
                return encoder && !encodeValuesOnly ? encoder(prefix, defaults$1.encoder, charset, 'key') : prefix;
            }

            obj = '';
        }

        if (isNonNullishPrimitive(obj) || utils$1.isBuffer(obj)) {
            if (encoder) {
                var keyValue = encodeValuesOnly ? prefix : encoder(prefix, defaults$1.encoder, charset, 'key');
                return [formatter(keyValue) + '=' + formatter(encoder(obj, defaults$1.encoder, charset, 'value'))];
            }
            return [formatter(prefix) + '=' + formatter(String(obj))];
        }

        var values = [];

        if (typeof obj === 'undefined') {
            return values;
        }

        var objKeys;
        if (isArray$2(filter)) {
            objKeys = filter;
        } else {
            var keys = Object.keys(obj);
            objKeys = sort ? keys.sort(sort) : keys;
        }

        for (var i = 0; i < objKeys.length; ++i) {
            var key = objKeys[i];

            if (skipNulls && obj[key] === null) {
                continue;
            }

            if (isArray$2(obj)) {
                pushToArray(values, stringify(
                    obj[key],
                    typeof generateArrayPrefix === 'function' ? generateArrayPrefix(prefix, key) : prefix,
                    generateArrayPrefix,
                    strictNullHandling,
                    skipNulls,
                    encoder,
                    filter,
                    sort,
                    allowDots,
                    serializeDate,
                    formatter,
                    encodeValuesOnly,
                    charset
                ));
            } else {
                pushToArray(values, stringify(
                    obj[key],
                    prefix + (allowDots ? '.' + key : '[' + key + ']'),
                    generateArrayPrefix,
                    strictNullHandling,
                    skipNulls,
                    encoder,
                    filter,
                    sort,
                    allowDots,
                    serializeDate,
                    formatter,
                    encodeValuesOnly,
                    charset
                ));
            }
        }

        return values;
    };

    var normalizeStringifyOptions = function normalizeStringifyOptions(opts) {
        if (!opts) {
            return defaults$1;
        }

        if (opts.encoder !== null && opts.encoder !== undefined && typeof opts.encoder !== 'function') {
            throw new TypeError('Encoder has to be a function.');
        }

        var charset = opts.charset || defaults$1.charset;
        if (typeof opts.charset !== 'undefined' && opts.charset !== 'utf-8' && opts.charset !== 'iso-8859-1') {
            throw new TypeError('The charset option must be either utf-8, iso-8859-1, or undefined');
        }

        var format = formats['default'];
        if (typeof opts.format !== 'undefined') {
            if (!has$2.call(formats.formatters, opts.format)) {
                throw new TypeError('Unknown format option provided.');
            }
            format = opts.format;
        }
        var formatter = formats.formatters[format];

        var filter = defaults$1.filter;
        if (typeof opts.filter === 'function' || isArray$2(opts.filter)) {
            filter = opts.filter;
        }

        return {
            addQueryPrefix: typeof opts.addQueryPrefix === 'boolean' ? opts.addQueryPrefix : defaults$1.addQueryPrefix,
            allowDots: typeof opts.allowDots === 'undefined' ? defaults$1.allowDots : !!opts.allowDots,
            charset: charset,
            charsetSentinel: typeof opts.charsetSentinel === 'boolean' ? opts.charsetSentinel : defaults$1.charsetSentinel,
            delimiter: typeof opts.delimiter === 'undefined' ? defaults$1.delimiter : opts.delimiter,
            encode: typeof opts.encode === 'boolean' ? opts.encode : defaults$1.encode,
            encoder: typeof opts.encoder === 'function' ? opts.encoder : defaults$1.encoder,
            encodeValuesOnly: typeof opts.encodeValuesOnly === 'boolean' ? opts.encodeValuesOnly : defaults$1.encodeValuesOnly,
            filter: filter,
            formatter: formatter,
            serializeDate: typeof opts.serializeDate === 'function' ? opts.serializeDate : defaults$1.serializeDate,
            skipNulls: typeof opts.skipNulls === 'boolean' ? opts.skipNulls : defaults$1.skipNulls,
            sort: typeof opts.sort === 'function' ? opts.sort : null,
            strictNullHandling: typeof opts.strictNullHandling === 'boolean' ? opts.strictNullHandling : defaults$1.strictNullHandling
        };
    };

    var stringify_1 = function (object, opts) {
        var obj = object;
        var options = normalizeStringifyOptions(opts);

        var objKeys;
        var filter;

        if (typeof options.filter === 'function') {
            filter = options.filter;
            obj = filter('', obj);
        } else if (isArray$2(options.filter)) {
            filter = options.filter;
            objKeys = filter;
        }

        var keys = [];

        if (typeof obj !== 'object' || obj === null) {
            return '';
        }

        var arrayFormat;
        if (opts && opts.arrayFormat in arrayPrefixGenerators) {
            arrayFormat = opts.arrayFormat;
        } else if (opts && 'indices' in opts) {
            arrayFormat = opts.indices ? 'indices' : 'repeat';
        } else {
            arrayFormat = 'indices';
        }

        var generateArrayPrefix = arrayPrefixGenerators[arrayFormat];

        if (!objKeys) {
            objKeys = Object.keys(obj);
        }

        if (options.sort) {
            objKeys.sort(options.sort);
        }

        for (var i = 0; i < objKeys.length; ++i) {
            var key = objKeys[i];

            if (options.skipNulls && obj[key] === null) {
                continue;
            }
            pushToArray(keys, stringify$1(
                obj[key],
                key,
                generateArrayPrefix,
                options.strictNullHandling,
                options.skipNulls,
                options.encode ? options.encoder : null,
                options.filter,
                options.sort,
                options.allowDots,
                options.serializeDate,
                options.formatter,
                options.encodeValuesOnly,
                options.charset
            ));
        }

        var joined = keys.join(options.delimiter);
        var prefix = options.addQueryPrefix === true ? '?' : '';

        if (options.charsetSentinel) {
            if (options.charset === 'iso-8859-1') {
                // encodeURIComponent('&#10003;'), the "numeric entity" representation of a checkmark
                prefix += 'utf8=%26%2310003%3B&';
            } else {
                // encodeURIComponent('✓')
                prefix += 'utf8=%E2%9C%93&';
            }
        }

        return joined.length > 0 ? prefix + joined : '';
    };

    'use strict';



    var has$3 = Object.prototype.hasOwnProperty;
    var isArray$3 = Array.isArray;

    var defaults$2 = {
        allowDots: false,
        allowPrototypes: false,
        arrayLimit: 20,
        charset: 'utf-8',
        charsetSentinel: false,
        comma: false,
        decoder: utils$1.decode,
        delimiter: '&',
        depth: 5,
        ignoreQueryPrefix: false,
        interpretNumericEntities: false,
        parameterLimit: 1000,
        parseArrays: true,
        plainObjects: false,
        strictNullHandling: false
    };

    var interpretNumericEntities = function (str) {
        return str.replace(/&#(\d+);/g, function ($0, numberStr) {
            return String.fromCharCode(parseInt(numberStr, 10));
        });
    };

    // This is what browsers will submit when the ✓ character occurs in an
    // application/x-www-form-urlencoded body and the encoding of the page containing
    // the form is iso-8859-1, or when the submitted form has an accept-charset
    // attribute of iso-8859-1. Presumably also with other charsets that do not contain
    // the ✓ character, such as us-ascii.
    var isoSentinel = 'utf8=%26%2310003%3B'; // encodeURIComponent('&#10003;')

    // These are the percent-encoded utf-8 octets representing a checkmark, indicating that the request actually is utf-8 encoded.
    var charsetSentinel = 'utf8=%E2%9C%93'; // encodeURIComponent('✓')

    var parseValues = function parseQueryStringValues(str, options) {
        var obj = {};
        var cleanStr = options.ignoreQueryPrefix ? str.replace(/^\?/, '') : str;
        var limit = options.parameterLimit === Infinity ? undefined : options.parameterLimit;
        var parts = cleanStr.split(options.delimiter, limit);
        var skipIndex = -1; // Keep track of where the utf8 sentinel was found
        var i;

        var charset = options.charset;
        if (options.charsetSentinel) {
            for (i = 0; i < parts.length; ++i) {
                if (parts[i].indexOf('utf8=') === 0) {
                    if (parts[i] === charsetSentinel) {
                        charset = 'utf-8';
                    } else if (parts[i] === isoSentinel) {
                        charset = 'iso-8859-1';
                    }
                    skipIndex = i;
                    i = parts.length; // The eslint settings do not allow break;
                }
            }
        }

        for (i = 0; i < parts.length; ++i) {
            if (i === skipIndex) {
                continue;
            }
            var part = parts[i];

            var bracketEqualsPos = part.indexOf(']=');
            var pos = bracketEqualsPos === -1 ? part.indexOf('=') : bracketEqualsPos + 1;

            var key, val;
            if (pos === -1) {
                key = options.decoder(part, defaults$2.decoder, charset, 'key');
                val = options.strictNullHandling ? null : '';
            } else {
                key = options.decoder(part.slice(0, pos), defaults$2.decoder, charset, 'key');
                val = options.decoder(part.slice(pos + 1), defaults$2.decoder, charset, 'value');
            }

            if (val && options.interpretNumericEntities && charset === 'iso-8859-1') {
                val = interpretNumericEntities(val);
            }

            if (val && typeof val === 'string' && options.comma && val.indexOf(',') > -1) {
                val = val.split(',');
            }

            if (part.indexOf('[]=') > -1) {
                val = isArray$3(val) ? [val] : val;
            }

            if (has$3.call(obj, key)) {
                obj[key] = utils$1.combine(obj[key], val);
            } else {
                obj[key] = val;
            }
        }

        return obj;
    };

    var parseObject = function (chain, val, options) {
        var leaf = val;

        for (var i = chain.length - 1; i >= 0; --i) {
            var obj;
            var root = chain[i];

            if (root === '[]' && options.parseArrays) {
                obj = [].concat(leaf);
            } else {
                obj = options.plainObjects ? Object.create(null) : {};
                var cleanRoot = root.charAt(0) === '[' && root.charAt(root.length - 1) === ']' ? root.slice(1, -1) : root;
                var index = parseInt(cleanRoot, 10);
                if (!options.parseArrays && cleanRoot === '') {
                    obj = { 0: leaf };
                } else if (
                    !isNaN(index)
                    && root !== cleanRoot
                    && String(index) === cleanRoot
                    && index >= 0
                    && (options.parseArrays && index <= options.arrayLimit)
                ) {
                    obj = [];
                    obj[index] = leaf;
                } else {
                    obj[cleanRoot] = leaf;
                }
            }

            leaf = obj;
        }

        return leaf;
    };

    var parseKeys = function parseQueryStringKeys(givenKey, val, options) {
        if (!givenKey) {
            return;
        }

        // Transform dot notation to bracket notation
        var key = options.allowDots ? givenKey.replace(/\.([^.[]+)/g, '[$1]') : givenKey;

        // The regex chunks

        var brackets = /(\[[^[\]]*])/;
        var child = /(\[[^[\]]*])/g;

        // Get the parent

        var segment = options.depth > 0 && brackets.exec(key);
        var parent = segment ? key.slice(0, segment.index) : key;

        // Stash the parent if it exists

        var keys = [];
        if (parent) {
            // If we aren't using plain objects, optionally prefix keys that would overwrite object prototype properties
            if (!options.plainObjects && has$3.call(Object.prototype, parent)) {
                if (!options.allowPrototypes) {
                    return;
                }
            }

            keys.push(parent);
        }

        // Loop through children appending to the array until we hit depth

        var i = 0;
        while (options.depth > 0 && (segment = child.exec(key)) !== null && i < options.depth) {
            i += 1;
            if (!options.plainObjects && has$3.call(Object.prototype, segment[1].slice(1, -1))) {
                if (!options.allowPrototypes) {
                    return;
                }
            }
            keys.push(segment[1]);
        }

        // If there's a remainder, just add whatever is left

        if (segment) {
            keys.push('[' + key.slice(segment.index) + ']');
        }

        return parseObject(keys, val, options);
    };

    var normalizeParseOptions = function normalizeParseOptions(opts) {
        if (!opts) {
            return defaults$2;
        }

        if (opts.decoder !== null && opts.decoder !== undefined && typeof opts.decoder !== 'function') {
            throw new TypeError('Decoder has to be a function.');
        }

        if (typeof opts.charset !== 'undefined' && opts.charset !== 'utf-8' && opts.charset !== 'iso-8859-1') {
            throw new Error('The charset option must be either utf-8, iso-8859-1, or undefined');
        }
        var charset = typeof opts.charset === 'undefined' ? defaults$2.charset : opts.charset;

        return {
            allowDots: typeof opts.allowDots === 'undefined' ? defaults$2.allowDots : !!opts.allowDots,
            allowPrototypes: typeof opts.allowPrototypes === 'boolean' ? opts.allowPrototypes : defaults$2.allowPrototypes,
            arrayLimit: typeof opts.arrayLimit === 'number' ? opts.arrayLimit : defaults$2.arrayLimit,
            charset: charset,
            charsetSentinel: typeof opts.charsetSentinel === 'boolean' ? opts.charsetSentinel : defaults$2.charsetSentinel,
            comma: typeof opts.comma === 'boolean' ? opts.comma : defaults$2.comma,
            decoder: typeof opts.decoder === 'function' ? opts.decoder : defaults$2.decoder,
            delimiter: typeof opts.delimiter === 'string' || utils$1.isRegExp(opts.delimiter) ? opts.delimiter : defaults$2.delimiter,
            // eslint-disable-next-line no-implicit-coercion, no-extra-parens
            depth: (typeof opts.depth === 'number' || opts.depth === false) ? +opts.depth : defaults$2.depth,
            ignoreQueryPrefix: opts.ignoreQueryPrefix === true,
            interpretNumericEntities: typeof opts.interpretNumericEntities === 'boolean' ? opts.interpretNumericEntities : defaults$2.interpretNumericEntities,
            parameterLimit: typeof opts.parameterLimit === 'number' ? opts.parameterLimit : defaults$2.parameterLimit,
            parseArrays: opts.parseArrays !== false,
            plainObjects: typeof opts.plainObjects === 'boolean' ? opts.plainObjects : defaults$2.plainObjects,
            strictNullHandling: typeof opts.strictNullHandling === 'boolean' ? opts.strictNullHandling : defaults$2.strictNullHandling
        };
    };

    var parse$1 = function (str, opts) {
        var options = normalizeParseOptions(opts);

        if (str === '' || str === null || typeof str === 'undefined') {
            return options.plainObjects ? Object.create(null) : {};
        }

        var tempObj = typeof str === 'string' ? parseValues(str, options) : str;
        var obj = options.plainObjects ? Object.create(null) : {};

        // Iterate over the keys and setup the new object

        var keys = Object.keys(tempObj);
        for (var i = 0; i < keys.length; ++i) {
            var key = keys[i];
            var newObj = parseKeys(key, tempObj[key], options);
            obj = utils$1.merge(obj, newObj, options);
        }

        return utils$1.compact(obj);
    };

    'use strict';





    var lib$1 = {
        formats: formats,
        parse: parse$1,
        stringify: stringify_1
    };
    var lib_1$1 = lib$1.formats;
    var lib_2$1 = lib$1.parse;
    var lib_3$1 = lib$1.stringify;

    var client = function(axios, { url, ...credentials }) {
        const config = {
            url,
            method: 'post',
            data: lib$1.stringify(credentials)
        };

        return () => axios(config).then(res => res.data);
    };

    function getMaxAge(res) {
        return res.expires_in;
    }

    function headerFormatter(res) {
        return 'Bearer ' + res.access_token;
    }

    var interceptor = function (tokenProvider, authenticate) {
        const getToken = tokenProvider.tokenCache(authenticate, { getMaxAge });
        return tokenProvider({ getToken, headerFormatter });
    };

    var src = {
        client: client,
        interceptor: interceptor
    };
    var src_1 = src.client;
    var src_2 = src.interceptor;

    'use strict';

    /**
     * Check if we're required to add a port number.
     *
     * @see https://url.spec.whatwg.org/#default-port
     * @param {Number|String} port Port number we need to check
     * @param {String} protocol Protocol we need to check against.
     * @returns {Boolean} Is it a default port for the given protocol
     * @api private
     */
    var requiresPort = function required(port, protocol) {
        protocol = protocol.split(':')[0];
        port = +port;

        if (!port) return false;

        switch (protocol) {
            case 'http':
            case 'ws':
                return port !== 80;

            case 'https':
            case 'wss':
                return port !== 443;

            case 'ftp':
                return port !== 21;

            case 'gopher':
                return port !== 70;

            case 'file':
                return false;
        }

        return port !== 0;
    };

    'use strict';

    var slashes = /^[A-Za-z][A-Za-z0-9+-.]*:\/\//
        , protocolre = /^([a-z][a-z0-9.+-]*:)?(\/\/)?([\S\s]*)/i
        , whitespace = '[\\x09\\x0A\\x0B\\x0C\\x0D\\x20\\xA0\\u1680\\u180E\\u2000\\u2001\\u2002\\u2003\\u2004\\u2005\\u2006\\u2007\\u2008\\u2009\\u200A\\u202F\\u205F\\u3000\\u2028\\u2029\\uFEFF]'
        , left = new RegExp('^'+ whitespace +'+');

    /**
     * Trim a given string.
     *
     * @param {String} str String to trim.
     * @public
     */
    function trimLeft(str) {
        return (str ? str : '').toString().replace(left, '');
    }

    /**
     * These are the parse rules for the URL parser, it informs the parser
     * about:
     *
     * 0. The char it Needs to parse, if it's a string it should be done using
     *    indexOf, RegExp using exec and NaN means set as current value.
     * 1. The property we should set when parsing this value.
     * 2. Indication if it's backwards or forward parsing, when set as number it's
     *    the value of extra chars that should be split off.
     * 3. Inherit from location if non existing in the parser.
     * 4. `toLowerCase` the resulting value.
     */
    var rules = [
        ['#', 'hash'],                        // Extract from the back.
        ['?', 'query'],                       // Extract from the back.
        function sanitize(address) {          // Sanitize what is left of the address
            return address.replace('\\', '/');
        },
        ['/', 'pathname'],                    // Extract from the back.
        ['@', 'auth', 1],                     // Extract from the front.
        [NaN, 'host', undefined, 1, 1],       // Set left over value.
        [/:(\d+)$/, 'port', undefined, 1],    // RegExp the back.
        [NaN, 'hostname', undefined, 1, 1]    // Set left over.
    ];

    /**
     * These properties should not be copied or inherited from. This is only needed
     * for all non blob URL's as a blob URL does not include a hash, only the
     * origin.
     *
     * @type {Object}
     * @private
     */
    var ignore = { hash: 1, query: 1 };

    /**
     * The location object differs when your code is loaded through a normal page,
     * Worker or through a worker using a blob. And with the blobble begins the
     * trouble as the location object will contain the URL of the blob, not the
     * location of the page where our code is loaded in. The actual origin is
     * encoded in the `pathname` so we can thankfully generate a good "default"
     * location from it so we can generate proper relative URL's again.
     *
     * @param {Object|String} loc Optional default location object.
     * @returns {Object} lolcation object.
     * @public
     */
    function lolcation(loc) {
        var globalVar;

        if (typeof window !== 'undefined') globalVar = window;
        else if (typeof commonjsGlobal !== 'undefined') globalVar = commonjsGlobal;
        else if (typeof self !== 'undefined') globalVar = self;
        else globalVar = {};

        var location = globalVar.location || {};
        loc = loc || location;

        var finaldestination = {}
            , type = typeof loc
            , key;

        if ('blob:' === loc.protocol) {
            finaldestination = new Url(unescape(loc.pathname), {});
        } else if ('string' === type) {
            finaldestination = new Url(loc, {});
            for (key in ignore) delete finaldestination[key];
        } else if ('object' === type) {
            for (key in loc) {
                if (key in ignore) continue;
                finaldestination[key] = loc[key];
            }

            if (finaldestination.slashes === undefined) {
                finaldestination.slashes = slashes.test(loc.href);
            }
        }

        return finaldestination;
    }

    /**
     * @typedef ProtocolExtract
     * @type Object
     * @property {String} protocol Protocol matched in the URL, in lowercase.
     * @property {Boolean} slashes `true` if protocol is followed by "//", else `false`.
     * @property {String} rest Rest of the URL that is not part of the protocol.
     */

    /**
     * Extract protocol information from a URL with/without double slash ("//").
     *
     * @param {String} address URL we want to extract from.
     * @return {ProtocolExtract} Extracted information.
     * @private
     */
    function extractProtocol(address) {
        address = trimLeft(address);
        var match = protocolre.exec(address);

        return {
            protocol: match[1] ? match[1].toLowerCase() : '',
            slashes: !!match[2],
            rest: match[3]
        };
    }

    /**
     * Resolve a relative URL pathname against a base URL pathname.
     *
     * @param {String} relative Pathname of the relative URL.
     * @param {String} base Pathname of the base URL.
     * @return {String} Resolved pathname.
     * @private
     */
    function resolve(relative, base) {
        if (relative === '') return base;

        var path = (base || '/').split('/').slice(0, -1).concat(relative.split('/'))
            , i = path.length
            , last = path[i - 1]
            , unshift = false
            , up = 0;

        while (i--) {
            if (path[i] === '.') {
                path.splice(i, 1);
            } else if (path[i] === '..') {
                path.splice(i, 1);
                up++;
            } else if (up) {
                if (i === 0) unshift = true;
                path.splice(i, 1);
                up--;
            }
        }

        if (unshift) path.unshift('');
        if (last === '.' || last === '..') path.push('');

        return path.join('/');
    }

    /**
     * The actual URL instance. Instead of returning an object we've opted-in to
     * create an actual constructor as it's much more memory efficient and
     * faster and it pleases my OCD.
     *
     * It is worth noting that we should not use `URL` as class name to prevent
     * clashes with the global URL instance that got introduced in browsers.
     *
     * @constructor
     * @param {String} address URL we want to parse.
     * @param {Object|String} [location] Location defaults for relative paths.
     * @param {Boolean|Function} [parser] Parser for the query string.
     * @private
     */
    function Url(address, location, parser) {
        address = trimLeft(address);

        if (!(this instanceof Url)) {
            return new Url(address, location, parser);
        }

        var relative, extracted, parse, instruction, index, key
            , instructions = rules.slice()
            , type = typeof location
            , url = this
            , i = 0;

        //
        // The following if statements allows this module two have compatibility with
        // 2 different API:
        //
        // 1. Node.js's `url.parse` api which accepts a URL, boolean as arguments
        //    where the boolean indicates that the query string should also be parsed.
        //
        // 2. The `URL` interface of the browser which accepts a URL, object as
        //    arguments. The supplied object will be used as default values / fall-back
        //    for relative paths.
        //
        if ('object' !== type && 'string' !== type) {
            parser = location;
            location = null;
        }

        if (parser && 'function' !== typeof parser) parser = querystringify_1.parse;

        location = lolcation(location);

        //
        // Extract protocol information before running the instructions.
        //
        extracted = extractProtocol(address || '');
        relative = !extracted.protocol && !extracted.slashes;
        url.slashes = extracted.slashes || relative && location.slashes;
        url.protocol = extracted.protocol || location.protocol || '';
        address = extracted.rest;

        //
        // When the authority component is absent the URL starts with a path
        // component.
        //
        if (!extracted.slashes) instructions[3] = [/(.*)/, 'pathname'];

        for (; i < instructions.length; i++) {
            instruction = instructions[i];

            if (typeof instruction === 'function') {
                address = instruction(address);
                continue;
            }

            parse = instruction[0];
            key = instruction[1];

            if (parse !== parse) {
                url[key] = address;
            } else if ('string' === typeof parse) {
                if (~(index = address.indexOf(parse))) {
                    if ('number' === typeof instruction[2]) {
                        url[key] = address.slice(0, index);
                        address = address.slice(index + instruction[2]);
                    } else {
                        url[key] = address.slice(index);
                        address = address.slice(0, index);
                    }
                }
            } else if ((index = parse.exec(address))) {
                url[key] = index[1];
                address = address.slice(0, index.index);
            }

            url[key] = url[key] || (
                relative && instruction[3] ? location[key] || '' : ''
            );

            //
            // Hostname, host and protocol should be lowercased so they can be used to
            // create a proper `origin`.
            //
            if (instruction[4]) url[key] = url[key].toLowerCase();
        }

        //
        // Also parse the supplied query string in to an object. If we're supplied
        // with a custom parser as function use that instead of the default build-in
        // parser.
        //
        if (parser) url.query = parser(url.query);

        //
        // If the URL is relative, resolve the pathname against the base URL.
        //
        if (
            relative
            && location.slashes
            && url.pathname.charAt(0) !== '/'
            && (url.pathname !== '' || location.pathname !== '')
        ) {
            url.pathname = resolve(url.pathname, location.pathname);
        }

        //
        // We should not add port numbers if they are already the default port number
        // for a given protocol. As the host also contains the port number we're going
        // override it with the hostname which contains no port number.
        //
        if (!requiresPort(url.port, url.protocol)) {
            url.host = url.hostname;
            url.port = '';
        }

        //
        // Parse down the `auth` for the username and password.
        //
        url.username = url.password = '';
        if (url.auth) {
            instruction = url.auth.split(':');
            url.username = instruction[0] || '';
            url.password = instruction[1] || '';
        }

        url.origin = url.protocol && url.host && url.protocol !== 'file:'
            ? url.protocol +'//'+ url.host
            : 'null';

        //
        // The href is just the compiled result.
        //
        url.href = url.toString();
    }

    /**
     * This is convenience method for changing properties in the URL instance to
     * insure that they all propagate correctly.
     *
     * @param {String} part          Property we need to adjust.
     * @param {Mixed} value          The newly assigned value.
     * @param {Boolean|Function} fn  When setting the query, it will be the function
     *                               used to parse the query.
     *                               When setting the protocol, double slash will be
     *                               removed from the final url if it is true.
     * @returns {URL} URL instance for chaining.
     * @public
     */
    function set(part, value, fn) {
        var url = this;

        switch (part) {
            case 'query':
                if ('string' === typeof value && value.length) {
                    value = (fn || querystringify_1.parse)(value);
                }

                url[part] = value;
                break;

            case 'port':
                url[part] = value;

                if (!requiresPort(value, url.protocol)) {
                    url.host = url.hostname;
                    url[part] = '';
                } else if (value) {
                    url.host = url.hostname +':'+ value;
                }

                break;

            case 'hostname':
                url[part] = value;

                if (url.port) value += ':'+ url.port;
                url.host = value;
                break;

            case 'host':
                url[part] = value;

                if (/:\d+$/.test(value)) {
                    value = value.split(':');
                    url.port = value.pop();
                    url.hostname = value.join(':');
                } else {
                    url.hostname = value;
                    url.port = '';
                }

                break;

            case 'protocol':
                url.protocol = value.toLowerCase();
                url.slashes = !fn;
                break;

            case 'pathname':
            case 'hash':
                if (value) {
                    var char = part === 'pathname' ? '/' : '#';
                    url[part] = value.charAt(0) !== char ? char + value : value;
                } else {
                    url[part] = value;
                }
                break;

            default:
                url[part] = value;
        }

        for (var i = 0; i < rules.length; i++) {
            var ins = rules[i];

            if (ins[4]) url[ins[1]] = url[ins[1]].toLowerCase();
        }

        url.origin = url.protocol && url.host && url.protocol !== 'file:'
            ? url.protocol +'//'+ url.host
            : 'null';

        url.href = url.toString();

        return url;
    }

    /**
     * Transform the properties back in to a valid and full URL string.
     *
     * @param {Function} stringify Optional query stringify function.
     * @returns {String} Compiled version of the URL.
     * @public
     */
    function toString$1(stringify) {
        if (!stringify || 'function' !== typeof stringify) stringify = querystringify_1.stringify;

        var query
            , url = this
            , protocol = url.protocol;

        if (protocol && protocol.charAt(protocol.length - 1) !== ':') protocol += ':';

        var result = protocol + (url.slashes ? '//' : '');

        if (url.username) {
            result += url.username;
            if (url.password) result += ':'+ url.password;
            result += '@';
        }

        result += url.host + url.pathname;

        query = 'object' === typeof url.query ? stringify(url.query) : url.query;
        if (query) result += '?' !== query.charAt(0) ? '?'+ query : query;

        if (url.hash) result += url.hash;

        return result;
    }

    Url.prototype = { set: set, toString: toString$1 };

    //
    // Expose the URL parser and some additional properties that might be useful for
    // others or testing.
    //
    Url.extractProtocol = extractProtocol;
    Url.location = lolcation;
    Url.trimLeft = trimLeft;
    Url.qs = querystringify_1;

    var urlParse = Url;

    var index_min = createCommonjsModule(function (module) {
        module.exports=function(e){var t={};function r(n){if(t[n])return t[n].exports;var o=t[n]={i:n,l:!1,exports:{}};return e[n].call(o.exports,o,o.exports,r),o.l=!0,o.exports}return r.m=e,r.c=t,r.d=function(e,t,n){r.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:n});},r.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0});},r.t=function(e,t){if(1&t&&(e=r(e)),8&t)return e;if(4&t&&"object"==typeof e&&e&&e.__esModule)return e;var n=Object.create(null);if(r.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var o in e)r.d(n,o,function(t){return e[t]}.bind(null,o));return n},r.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return r.d(t,"a",t),t},r.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},r.p="",r(r.s=0)}([function(e,t,r){"use strict";r.r(t);var n={statusCodes:[401]};t.default=function e(t,r){var o=arguments.length>2&&void 0!==arguments[2]?arguments[2]:{},u=t.interceptors.response.use(function(e){return e},function(s){var i=o.hasOwnProperty("statusCodes")&&o.statusCodes.length?o.statusCodes:n.statusCodes;if(!s.response||s.response.status&&-1===i.indexOf(+s.response.status))return Promise.reject(s);t.interceptors.response.eject(u);var c=r(s),f=t.interceptors.request.use(function(e){return c.then(function(){return e})});return c.then(function(){return t.interceptors.request.eject(f),t(s.response.config)}).catch(function(e){return t.interceptors.request.eject(f),Promise.reject(e)}).finally(function(){return e(t,r,o)})});return t};}]);
    });

    var createAuthRefreshInterceptor = unwrapExports(index_min);

    /* global DOMException */

    var clipboardCopy_1 = clipboardCopy;

    function clipboardCopy (text) {
        // Use the Async Clipboard API when available. Requires a secure browing
        // context (i.e. HTTPS)
        if (navigator.clipboard) {
            return navigator.clipboard.writeText(text).catch(function (err) {
                throw (err !== undefined ? err : new DOMException('The request is not allowed', 'NotAllowedError'))
            })
        }

        // ...Otherwise, use document.execCommand() fallback

        // Put the text to copy into a <span>
        var span = document.createElement('span');
        span.textContent = text;

        // Preserve consecutive spaces and newlines
        span.style.whiteSpace = 'pre';

        // Add the <span> to the page
        document.body.appendChild(span);

        // Make a selection object representing the range of text selected by the user
        var selection = window.getSelection();
        var range = window.document.createRange();
        selection.removeAllRanges();
        range.selectNode(span);
        selection.addRange(range);

        // Copy text to the clipboard
        var success = false;
        try {
            success = window.document.execCommand('copy');
        } catch (err) {
            console.log('error', err);
        }

        // Cleanup
        selection.removeAllRanges();
        window.document.body.removeChild(span);

        return success
            ? Promise.resolve()
            : Promise.reject(new DOMException('The request is not allowed', 'NotAllowedError'))
    }

    const subscriber_queue = [];
    /**
     * Creates a `Readable` store that allows reading by subscription.
     * @param value initial value
     * @param {StartStopNotifier}start start and stop notifications for subscriptions
     */
    function readable(value, start) {
        return {
            subscribe: writable(value, start).subscribe,
        };
    }
    /**
     * Create a `Writable` store that allows both updating and reading by subscription.
     * @param {*=}value initial value
     * @param {StartStopNotifier=}start start and stop notifications for subscriptions
     */
    function writable(value, start = noop) {
        let stop;
        const subscribers = [];
        function set(new_value) {
            if (safe_not_equal(value, new_value)) {
                value = new_value;
                if (stop) { // store is ready
                    const run_queue = !subscriber_queue.length;
                    for (let i = 0; i < subscribers.length; i += 1) {
                        const s = subscribers[i];
                        s[1]();
                        subscriber_queue.push(s, value);
                    }
                    if (run_queue) {
                        for (let i = 0; i < subscriber_queue.length; i += 2) {
                            subscriber_queue[i][0](subscriber_queue[i + 1]);
                        }
                        subscriber_queue.length = 0;
                    }
                }
            }
        }
        function update(fn) {
            set(fn(value));
        }
        function subscribe(run, invalidate = noop) {
            const subscriber = [run, invalidate];
            subscribers.push(subscriber);
            if (subscribers.length === 1) {
                stop = start(set) || noop;
            }
            run(value);
            return () => {
                const index = subscribers.indexOf(subscriber);
                if (index !== -1) {
                    subscribers.splice(index, 1);
                }
                if (subscribers.length === 0) {
                    stop();
                    stop = null;
                }
            };
        }
        return { set, update, subscribe };
    }
    function derived(stores, fn, initial_value) {
        const single = !Array.isArray(stores);
        const stores_array = single
            ? [stores]
            : stores;
        const auto = fn.length < 2;
        return readable(initial_value, (set) => {
            let inited = false;
            const values = [];
            let pending = 0;
            let cleanup = noop;
            const sync = () => {
                if (pending) {
                    return;
                }
                cleanup();
                const result = fn(single ? values[0] : values, set);
                if (auto) {
                    set(result);
                }
                else {
                    cleanup = is_function(result) ? result : noop;
                }
            };
            const unsubscribers = stores_array.map((store, i) => store.subscribe((value) => {
                values[i] = value;
                pending &= ~(1 << i);
                if (inited) {
                    sync();
                }
            }, () => {
                pending |= (1 << i);
            }));
            inited = true;
            sync();
            return function stop() {
                run_all(unsubscribers);
                cleanup();
            };
        });
    }

    const env = writable("");
    const token = writable("");

    env.subscribe(val => {
        if (val != "") {
            store2.set("env", val);
        }
    });

    function unique(value, index, self) {
        return self.indexOf(value) === index;
    }

    function add(data, val) {
        const arr = data.split(";");
        arr.push(val);

        return arr
            .filter(unique)
            .filter(String)
            .join(";");
    }

    function remove(data, val) {
        return data
            .split(";")
            .filter(v => v != val)
            .join(";");
    }

    function createAuth() {
        const { subscribe, update } = writable("");

        return {
            subscribe,
            add: val => update(data => add(data, val)),
            remove: val => update(data => remove(data, val))
        };
    }

    const auth = createAuth();

    prism.languages.json = {
        property: {
            pattern: /"(?:\\.|[^\\"\r\n])*"(?=\s*:)/,
            greedy: true
        },
        string: {
            pattern: /"(?:\\.|[^\\"\r\n])*"(?!\s*:)/,
            greedy: true
        },
        comment: /\/\/.*|\/\*[\s\S]*?(?:\*\/|$)/,
        number: /-?\d+\.?\d*(e[+-]?\d+)?/i,
        punctuation: /[{}[\],]/,
        operator: /:/,
        boolean: /\b(?:true|false)\b/,
        null: {
            pattern: /\bnull\b/,
            alias: "keyword"
        }
    };

    const highlight = function(code, lang) {
        const supported = ["xml", "json"];

        if (!supported.includes(lang)) {
            lang = "markup";
        }

        return prism.highlight(code, prism.languages[lang], lang);
    };

    marked.setOptions({
        highlight
    });

    const renderer = new marked.Renderer();

    renderer.pre = renderer.code;
    renderer.code = function(code, infostring, escaped) {
        const out = this.pre(code, infostring, escaped);
        return out.replace("<pre>", `<pre class="language-${infostring}">`);
    };

    const markdown = function(source) {
        return source ? marked(source, { renderer: renderer }) : "";
    };

    const toc = function(source) {
        if (!source) {
            return [];
        }

        const tokens = marked.lexer(source);
        const headings = tokens.filter(elem => elem.type === "heading");
        const depths = headings.map(head => head.depth);
        const minDepth = Math.min(...depths);

        return headings.map(head => ({
            text: head.text,
            level: head.depth - minDepth
        }));
    };

    const colorize = function(str, prefix = "is-") {
        switch (str) {
            case "get":
                return `${prefix}success`;
            case "post":
                return `${prefix}link`;
            case "put":
                return `${prefix}primary`;
            case "patch":
                return `${prefix}info`;
            case "delete":
                return `${prefix}danger`;
            case 200:
            case 201:
            case 202:
            case 204:
                return `${prefix}info`;
            case 401:
            case 403:
            case 404:
            case 422:
                return `${prefix}warning`;
            case 500:
                return `${prefix}danger`;
        }
    };

    const slugify = function(str) {
        return speakingurl$1(str, "-");
    };

    const alias = str => {
        return str && str.match("json") ? "json" : "markup";
    };

    const stringify$2 = obj => {
        if (typeof obj === "string") {
            return obj;
        }

        if (obj) {
            return JSON.stringify(obj, null, "  ");
        }

        return "";
    };

    const expandUrl = (uri, obj) => {
        const tpl = uritemplate.parse(uri);
        return tpl.expand(obj);
    };

    const actionFilter = (act, regex) => {
        return (
            act.path.match(regex) || act.method.match(regex) || act.title.match(regex)
        );
    };

    const filteredItem = (title, key, items) => {
        if (items.length === 0) {
            return false;
        }

        return { title: title, [key]: items };
    };

    function escape$2(text) {
        return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
    }

    const filterActions = (tagActions, query) => {
        if (query.startsWith("g:")) {
            return tagActions
                .map(tag => {
                    const children = tag.children.filter(child => {
                        return slugify(child.title) === query.substr(2);
                    });

                    return filteredItem(tag.title, "children", children.filter(Boolean));
                })
                .filter(Boolean);
        }

        if (query.startsWith("rg:")) {
            return tagActions
                .map(tag => {
                    const children = tag.children.filter(
                        () => slugify(tag.title) === query.substr(3)
                    );

                    return filteredItem(tag.title, "children", children.filter(Boolean));
                })
                .filter(Boolean);
        }

        const regex = new RegExp(escape$2(query), "gi");

        return tagActions
            .map(tag => {
                const children = tag.children.map(child => {
                    const actions = child.actions.filter(act => actionFilter(act, regex));
                    return filteredItem(child.title, "actions", actions);
                });

                return filteredItem(tag.title, "children", children.filter(Boolean));
            })
            .filter(Boolean);
    };

    const basePath = config => {
        if (config.basePath.endsWith("/")) {
            return config.basePath;
        } else {
            return config.basePath + "/";
        }
    };

    const tokenName = env => `token:${env}`;
    const setToken = (env, token) => store2.session.set(tokenName(env), token);
    const getToken = env => store2.session.get(tokenName(env));
    const removeToken = env => store2.session.remove(tokenName(env));

    const refreshTokenName = env => `refresh-token:${env}`;
    const setRefreshToken = (env, token) =>
        store2.session.set(refreshTokenName(env), token);
    const getRefreshToken = env => store2.session.get(refreshTokenName(env));
    const removeRefreshToken = env => store2.session.remove(refreshTokenName(env));

    const isAuth = (environment, name) => {
        return environment.auth && environment.auth.name === name;
    };

    const pushHistory = href => history.pushState(history.state, "", href);

    const requestToken = async (client, options) => {
        const authRequest = src.client(client, options);
        const authCode = await authRequest();

        if (typeof authCode === "string") {
            const authParsed = querystringify_1.parse(authCode);
            return {
                accessToken: authParsed.access_token,
                refreshToken: authParsed.refresh_token
            };
        }

        return {
            accessToken: authCode.access_token,
            refreshToken: authCode.refresh_token
        };
    };

    const exchangeToken = async (code, options, isPKCE, pkceChallenge) => {
        if (isPKCE) {
            return requestToken(axios$1.create(), {
                url: options.tokenUrl,
                grant_type: "authorization_code",
                client_id: options.clientId,
                redirect_uri: options.callbackUrl,
                code: code,
                code_verifier: pkceChallenge.code_verifier
            });
        }

        return requestToken(axios$1.create(), {
            url: options.tokenUrl,
            grant_type: "authorization_code",
            client_id: options.clientId,
            client_secret: options.clientSecret,
            redirect_uri: options.callbackUrl,
            code: code
        });
    };

    const populate = arr => {
        return arr
            .filter(obj => obj.used)
            .reduce((prev, cur) => {
                prev[cur.name] = cur.value;
                return prev;
            }, {});
    };

    const allowBody = action => {
        return ["put", "post", "patch"].includes(action.method);
    };

    const refreshInterceptor = (env, options) => {
        const refreshToken = getRefreshToken(env);

        return async failedRequest => {
            const {
                accessToken: newAccessToken,
                refreshToken: newRefreshToken
            } = await requestToken(axios$1, {
                url: options.tokenUrl,
                grant_type: "refresh_token",
                client_id: options.clientId,
                client_secret: options.clientSecret,
                refresh_token: refreshToken
            });

            if (newAccessToken) {
                token.set(newAccessToken);
                setToken(env, newAccessToken);
            }

            if (newRefreshToken) {
                setRefreshToken(env, newRefreshToken);
            }

            failedRequest.response.config.headers[
                "Authorization"
                ] = `Bearer ${newAccessToken}`;
        };
    };

    const sendRequest = (
        env,
        environment,
        action,
        { headers, parameters, body }
    ) => {
        const client = axios$1.create({
            baseURL: environment.url
        });

        const options = {
            method: action.method,
            headers: populate(headers)
        };

        if (environment.auth) {
            switch (environment.auth.name) {
                case "basic":
                    options.auth = environment.auth.options;
                    break;
                case "apikey":
                    options.headers[environment.auth.options.header] =
                        environment.auth.options.key;
                    break;
                case "oauth2":
                    options.headers["Authorization"] = `Bearer ${getToken(env)}`;
                    break;
                case "oauth2-pkce":
                    options.headers["Authorization"] = `Bearer ${getToken(env)}`;
                    break;
            }
        }

        const expandedUrl = expandUrl(action.pathTemplate, populate(parameters));
        const destUrl = urlParse(expandedUrl, true);

        options.params = destUrl.query;
        options.url = destUrl.pathname;

        if (allowBody(action)) {
            options.data = body;
        }

        if (isAuth(environment, "oauth2") || isAuth(environment, "oauth2-pkce")) {
            createAuthRefreshInterceptor(
                client,
                refreshInterceptor(env, environment.auth.options)
            );
        }

        return client.request(options);
    };

    const copyUrl = (url, parameters) => {
        const expandedUrl = expandUrl(url.pathname, populate(parameters));

        clipboardCopy_1(url.origin + expandedUrl);
    };

    const getEnv = () => store2.get("env");

    /* app/templates/winter/components/MenuItem.svelte generated by Svelte v3.16.5 */

    function add_css() {
        var style = element("style");
        style.id = "svelte-39af3j-style";
        style.textContent = ".tag.svelte-39af3j{width:3.5rem}.menu-ellipsis.svelte-39af3j{text-overflow:ellipsis;white-space:nowrap;overflow:hidden;padding:0.25em 0.75em}.menu-action.svelte-39af3j{vertical-align:middle}";
        append(document.head, style);
    }

    function get_each_context(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[7] = list[i];
        return child_ctx;
    }

    // (30:0) {#if title}
    function create_if_block_1(ctx) {
        let li;
        let a0;
        let t0;
        let a0_data_slug_value;
        let a0_href_value;
        let t1;
        let a1;
        let span;
        let i;
        let dispose;

        return {
            c() {
                li = element("li");
                a0 = element("a");
                t0 = text(/*title*/ ctx[1]);
                t1 = space();
                a1 = element("a");
                span = element("span");
                i = element("i");
                attr(a0, "data-slug", a0_data_slug_value = slugify(/*title*/ ctx[1]));
                attr(a0, "href", a0_href_value = "#/g~" + slugify(/*title*/ ctx[1]));
                attr(a0, "class", "is-inline-block");
                attr(i, "class", "fas");
                toggle_class(i, "fa-chevron-right", /*hidden*/ ctx[0]);
                toggle_class(i, "fa-chevron-down", !/*hidden*/ ctx[0]);
                attr(span, "class", "icon is-small has-text-grey-light");
                attr(a1, "href", "javascript:void(0)");
                attr(a1, "class", "is-inline-block is-pulled-right");

                dispose = [
                    listen(a0, "click", /*handleGroupClick*/ ctx[5]),
                    listen(a1, "click", /*click_handler*/ ctx[6])
                ];
            },
            m(target, anchor) {
                insert(target, li, anchor);
                append(li, a0);
                append(a0, t0);
                append(li, t1);
                append(li, a1);
                append(a1, span);
                append(span, i);
            },
            p(ctx, dirty) {
                if (dirty & /*title*/ 2) set_data(t0, /*title*/ ctx[1]);

                if (dirty & /*title*/ 2 && a0_data_slug_value !== (a0_data_slug_value = slugify(/*title*/ ctx[1]))) {
                    attr(a0, "data-slug", a0_data_slug_value);
                }

                if (dirty & /*title*/ 2 && a0_href_value !== (a0_href_value = "#/g~" + slugify(/*title*/ ctx[1]))) {
                    attr(a0, "href", a0_href_value);
                }

                if (dirty & /*hidden*/ 1) {
                    toggle_class(i, "fa-chevron-right", /*hidden*/ ctx[0]);
                }

                if (dirty & /*hidden*/ 1) {
                    toggle_class(i, "fa-chevron-down", !/*hidden*/ ctx[0]);
                }
            },
            d(detaching) {
                if (detaching) detach(li);
                run_all(dispose);
            }
        };
    }

    // (53:0) {#if actions.length > 0}
    function create_if_block(ctx) {
        let li;
        let ul;
        let each_value = /*actions*/ ctx[2];
        let each_blocks = [];

        for (let i = 0; i < each_value.length; i += 1) {
            each_blocks[i] = create_each_block(get_each_context(ctx, each_value, i));
        }

        return {
            c() {
                li = element("li");
                ul = element("ul");

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].c();
                }

                toggle_class(li, "is-hidden", /*hidden*/ ctx[0]);
            },
            m(target, anchor) {
                insert(target, li, anchor);
                append(li, ul);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].m(ul, null);
                }
            },
            p(ctx, dirty) {
                if (dirty & /*actions, currentSlug, handleClick, colorize*/ 28) {
                    each_value = /*actions*/ ctx[2];
                    let i;

                    for (i = 0; i < each_value.length; i += 1) {
                        const child_ctx = get_each_context(ctx, each_value, i);

                        if (each_blocks[i]) {
                            each_blocks[i].p(child_ctx, dirty);
                        } else {
                            each_blocks[i] = create_each_block(child_ctx);
                            each_blocks[i].c();
                            each_blocks[i].m(ul, null);
                        }
                    }

                    for (; i < each_blocks.length; i += 1) {
                        each_blocks[i].d(1);
                    }

                    each_blocks.length = each_value.length;
                }

                if (dirty & /*hidden*/ 1) {
                    toggle_class(li, "is-hidden", /*hidden*/ ctx[0]);
                }
            },
            d(detaching) {
                if (detaching) detach(li);
                destroy_each(each_blocks, detaching);
            }
        };
    }

    // (56:6) {#each actions as action}
    function create_each_block(ctx) {
        let li;
        let a;
        let code;
        let t0_value = /*action*/ ctx[7].method + "";
        let t0;
        let code_class_value;
        let t1;
        let span;
        let t2_value = /*action*/ ctx[7].title + "";
        let t2;
        let a_data_slug_value;
        let a_href_value;
        let t3;
        let dispose;

        return {
            c() {
                li = element("li");
                a = element("a");
                code = element("code");
                t0 = text(t0_value);
                t1 = space();
                span = element("span");
                t2 = text(t2_value);
                t3 = space();
                attr(code, "class", code_class_value = "tag " + colorize(/*action*/ ctx[7].method) + " is-uppercase" + " svelte-39af3j");
                attr(span, "class", "menu-action svelte-39af3j");
                attr(a, "data-slug", a_data_slug_value = /*action*/ ctx[7].slug);
                attr(a, "href", a_href_value = "#/" + /*action*/ ctx[7].slug);
                attr(a, "class", "menu-ellipsis svelte-39af3j");
                toggle_class(a, "is-active", /*action*/ ctx[7].slug === /*currentSlug*/ ctx[3]);
                dispose = listen(a, "click", /*handleClick*/ ctx[4]);
            },
            m(target, anchor) {
                insert(target, li, anchor);
                append(li, a);
                append(a, code);
                append(code, t0);
                append(a, t1);
                append(a, span);
                append(span, t2);
                append(li, t3);
            },
            p(ctx, dirty) {
                if (dirty & /*actions*/ 4 && t0_value !== (t0_value = /*action*/ ctx[7].method + "")) set_data(t0, t0_value);

                if (dirty & /*actions*/ 4 && code_class_value !== (code_class_value = "tag " + colorize(/*action*/ ctx[7].method) + " is-uppercase" + " svelte-39af3j")) {
                    attr(code, "class", code_class_value);
                }

                if (dirty & /*actions*/ 4 && t2_value !== (t2_value = /*action*/ ctx[7].title + "")) set_data(t2, t2_value);

                if (dirty & /*actions*/ 4 && a_data_slug_value !== (a_data_slug_value = /*action*/ ctx[7].slug)) {
                    attr(a, "data-slug", a_data_slug_value);
                }

                if (dirty & /*actions*/ 4 && a_href_value !== (a_href_value = "#/" + /*action*/ ctx[7].slug)) {
                    attr(a, "href", a_href_value);
                }

                if (dirty & /*actions, currentSlug*/ 12) {
                    toggle_class(a, "is-active", /*action*/ ctx[7].slug === /*currentSlug*/ ctx[3]);
                }
            },
            d(detaching) {
                if (detaching) detach(li);
                dispose();
            }
        };
    }

    function create_fragment(ctx) {
        let t;
        let if_block1_anchor;
        let if_block0 = /*title*/ ctx[1] && create_if_block_1(ctx);
        let if_block1 = /*actions*/ ctx[2].length > 0 && create_if_block(ctx);

        return {
            c() {
                if (if_block0) if_block0.c();
                t = space();
                if (if_block1) if_block1.c();
                if_block1_anchor = empty();
            },
            m(target, anchor) {
                if (if_block0) if_block0.m(target, anchor);
                insert(target, t, anchor);
                if (if_block1) if_block1.m(target, anchor);
                insert(target, if_block1_anchor, anchor);
            },
            p(ctx, [dirty]) {
                if (/*title*/ ctx[1]) {
                    if (if_block0) {
                        if_block0.p(ctx, dirty);
                    } else {
                        if_block0 = create_if_block_1(ctx);
                        if_block0.c();
                        if_block0.m(t.parentNode, t);
                    }
                } else if (if_block0) {
                    if_block0.d(1);
                    if_block0 = null;
                }

                if (/*actions*/ ctx[2].length > 0) {
                    if (if_block1) {
                        if_block1.p(ctx, dirty);
                    } else {
                        if_block1 = create_if_block(ctx);
                        if_block1.c();
                        if_block1.m(if_block1_anchor.parentNode, if_block1_anchor);
                    }
                } else if (if_block1) {
                    if_block1.d(1);
                    if_block1 = null;
                }
            },
            i: noop,
            o: noop,
            d(detaching) {
                if (if_block0) if_block0.d(detaching);
                if (detaching) detach(t);
                if (if_block1) if_block1.d(detaching);
                if (detaching) detach(if_block1_anchor);
            }
        };
    }

    function instance($$self, $$props, $$invalidate) {
        let { title } = $$props;
        let { actions } = $$props;
        let { currentSlug } = $$props;
        let { hidden = false } = $$props;
        let { handleClick } = $$props;
        let { handleGroupClick } = $$props;
        const click_handler = () => $$invalidate(0, hidden = !hidden);

        $$self.$set = $$props => {
            if ("title" in $$props) $$invalidate(1, title = $$props.title);
            if ("actions" in $$props) $$invalidate(2, actions = $$props.actions);
            if ("currentSlug" in $$props) $$invalidate(3, currentSlug = $$props.currentSlug);
            if ("hidden" in $$props) $$invalidate(0, hidden = $$props.hidden);
            if ("handleClick" in $$props) $$invalidate(4, handleClick = $$props.handleClick);
            if ("handleGroupClick" in $$props) $$invalidate(5, handleGroupClick = $$props.handleGroupClick);
        };

        return [
            hidden,
            title,
            actions,
            currentSlug,
            handleClick,
            handleGroupClick,
            click_handler
        ];
    }

    class MenuItem extends SvelteComponent {
        constructor(options) {
            super();
            if (!document.getElementById("svelte-39af3j-style")) add_css();

            init(this, options, instance, create_fragment, safe_not_equal, {
                title: 1,
                actions: 2,
                currentSlug: 3,
                hidden: 0,
                handleClick: 4,
                handleGroupClick: 5
            });
        }
    }

    /* app/templates/winter/panels/MenuPanel.svelte generated by Svelte v3.16.5 */

    function add_css$1() {
        var style = element("style");
        style.id = "svelte-fvssqr-style";
        style.textContent = ".hero.svelte-fvssqr,.menu-wrapper.svelte-fvssqr{padding:0 2.75rem 0 2rem}.hero.svelte-fvssqr{position:sticky;top:54px;background-color:#fafafa;margin-bottom:1.5rem}.hero.is-darkmode.svelte-fvssqr{background-color:#000}.hero-body.svelte-fvssqr{padding:1.5rem 0;box-shadow:0 2px 0 0 #f5f5f5}.hero-body.is-darkmode.svelte-fvssqr{box-shadow:0 2px 0 0 #363636}.menu-wrapper.svelte-fvssqr::-webkit-scrollbar{display:none}@media screen and (min-width: 768px){.hero.svelte-fvssqr,.menu-wrapper.svelte-fvssqr{width:-moz-calc(25% - 0.5rem);width:-webkit-calc(25% - 0.5rem);width:-o-calc(25% - 0.5rem);width:calc(25% - 0.5rem)}.hero.svelte-fvssqr{position:fixed;padding:0 1.25rem}.menu-wrapper.svelte-fvssqr{position:fixed;top:140px;padding:1.5rem 1.25rem 1.25rem;height:-moz-calc(100% - 150px - 2.5rem);height:-webkit-calc(100% - 150px - 2.5rem);height:-o-calc(100% - 150px - 2.5rem);height:calc(100% - 150px - 2.5rem);overflow:-moz-scrollbars-none;-ms-overflow-style:none;overflow-x:hidden;overflow-y:auto;transition:opacity 0.3s, left 0.3s}.menu.is-collapsed.svelte-fvssqr{width:3rem}.is-collapsed.svelte-fvssqr .hero.svelte-fvssqr,.is-collapsed.svelte-fvssqr .hero-body.svelte-fvssqr{width:calc(3rem - 2px)}.is-collapsed.svelte-fvssqr .hero.svelte-fvssqr{padding-left:0;padding-right:0}.is-collapsed.svelte-fvssqr .hero-body.svelte-fvssqr{padding-left:0.3175rem;padding-right:0.3175rem;box-shadow:none}.is-collapsed.svelte-fvssqr .input.is-rounded.svelte-fvssqr{padding-left:0;padding-right:0;opacity:0}.is-collapsed.svelte-fvssqr .icon-input-search.svelte-fvssqr{color:#b5b5b5;background-color:#eee;-webkit-border-radius:50%;-moz-border-radius:50%;border-radius:50%;cursor:pointer;pointer-events:auto}.is-collapsed.svelte-fvssqr .icon-input-search.svelte-fvssqr:hover{color:#999;background-color:#e0e0e0}.is-collapsed.svelte-fvssqr .is-darkmode .icon-input-search.svelte-fvssqr{color:#ccc;background-color:#484848}.is-collapsed.svelte-fvssqr .is-darkmode .icon-input-search.svelte-fvssqr:hover{color:#fff;background-color:#484848}.is-collapsed.svelte-fvssqr .menu-wrapper.svelte-fvssqr{left:-30%;opacity:0}}";
        append(document.head, style);
    }

    function get_each_context_1(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[19] = list[i];
        return child_ctx;
    }

    function get_each_context$1(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[16] = list[i];
        return child_ctx;
    }

    function get_each_context_2(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[22] = list[i];
        return child_ctx;
    }

    // (169:4) {#if query === ''}
    function create_if_block_1$1(ctx) {
        let ul;
        let li;
        let a;
        let t0;
        let a_href_value;
        let t1;
        let dispose;
        let if_block = /*tagHeaders*/ ctx[3] && create_if_block_2(ctx);

        return {
            c() {
                ul = element("ul");
                li = element("li");
                a = element("a");
                t0 = text("Getting Started");
                t1 = space();
                if (if_block) if_block.c();
                attr(a, "href", a_href_value = basePath(/*config*/ ctx[2]));
                attr(ul, "class", "menu-list");
                dispose = listen(a, "click", prevent_default(/*tocClick*/ ctx[11]));
            },
            m(target, anchor) {
                insert(target, ul, anchor);
                append(ul, li);
                append(li, a);
                append(a, t0);
                append(ul, t1);
                if (if_block) if_block.m(ul, null);
            },
            p(ctx, dirty) {
                if (dirty & /*config*/ 4 && a_href_value !== (a_href_value = basePath(/*config*/ ctx[2]))) {
                    attr(a, "href", a_href_value);
                }

                if (/*tagHeaders*/ ctx[3]) {
                    if (if_block) {
                        if_block.p(ctx, dirty);
                    } else {
                        if_block = create_if_block_2(ctx);
                        if_block.c();
                        if_block.m(ul, null);
                    }
                } else if (if_block) {
                    if_block.d(1);
                    if_block = null;
                }
            },
            d(detaching) {
                if (detaching) detach(ul);
                if (if_block) if_block.d();
                dispose();
            }
        };
    }

    // (176:8) {#if tagHeaders}
    function create_if_block_2(ctx) {
        let li;
        let ul;
        let each_value_2 = /*tagHeaders*/ ctx[3];
        let each_blocks = [];

        for (let i = 0; i < each_value_2.length; i += 1) {
            each_blocks[i] = create_each_block_2(get_each_context_2(ctx, each_value_2, i));
        }

        return {
            c() {
                li = element("li");
                ul = element("ul");

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].c();
                }
            },
            m(target, anchor) {
                insert(target, li, anchor);
                append(li, ul);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].m(ul, null);
                }
            },
            p(ctx, dirty) {
                if (dirty & /*tagHeaders, headerLink, tocClick*/ 2056) {
                    each_value_2 = /*tagHeaders*/ ctx[3];
                    let i;

                    for (i = 0; i < each_value_2.length; i += 1) {
                        const child_ctx = get_each_context_2(ctx, each_value_2, i);

                        if (each_blocks[i]) {
                            each_blocks[i].p(child_ctx, dirty);
                        } else {
                            each_blocks[i] = create_each_block_2(child_ctx);
                            each_blocks[i].c();
                            each_blocks[i].m(ul, null);
                        }
                    }

                    for (; i < each_blocks.length; i += 1) {
                        each_blocks[i].d(1);
                    }

                    each_blocks.length = each_value_2.length;
                }
            },
            d(detaching) {
                if (detaching) detach(li);
                destroy_each(each_blocks, detaching);
            }
        };
    }

    // (180:16) {#if header.level === 0}
    function create_if_block_3(ctx) {
        let li;
        let a;
        let t0_value = /*header*/ ctx[22].text + "";
        let t0;
        let a_href_value;
        let t1;
        let dispose;

        return {
            c() {
                li = element("li");
                a = element("a");
                t0 = text(t0_value);
                t1 = space();
                attr(a, "href", a_href_value = "#" + headerLink(/*header*/ ctx[22].text));
                dispose = listen(a, "click", /*tocClick*/ ctx[11]);
            },
            m(target, anchor) {
                insert(target, li, anchor);
                append(li, a);
                append(a, t0);
                append(li, t1);
            },
            p(ctx, dirty) {
                if (dirty & /*tagHeaders*/ 8 && t0_value !== (t0_value = /*header*/ ctx[22].text + "")) set_data(t0, t0_value);

                if (dirty & /*tagHeaders*/ 8 && a_href_value !== (a_href_value = "#" + headerLink(/*header*/ ctx[22].text))) {
                    attr(a, "href", a_href_value);
                }
            },
            d(detaching) {
                if (detaching) detach(li);
                dispose();
            }
        };
    }

    // (179:14) {#each tagHeaders as header}
    function create_each_block_2(ctx) {
        let if_block_anchor;
        let if_block = /*header*/ ctx[22].level === 0 && create_if_block_3(ctx);

        return {
            c() {
                if (if_block) if_block.c();
                if_block_anchor = empty();
            },
            m(target, anchor) {
                if (if_block) if_block.m(target, anchor);
                insert(target, if_block_anchor, anchor);
            },
            p(ctx, dirty) {
                if (/*header*/ ctx[22].level === 0) {
                    if (if_block) {
                        if_block.p(ctx, dirty);
                    } else {
                        if_block = create_if_block_3(ctx);
                        if_block.c();
                        if_block.m(if_block_anchor.parentNode, if_block_anchor);
                    }
                } else if (if_block) {
                    if_block.d(1);
                    if_block = null;
                }
            },
            d(detaching) {
                if (if_block) if_block.d(detaching);
                if (detaching) detach(if_block_anchor);
            }
        };
    }

    // (195:6) {#if tag.title}
    function create_if_block$1(ctx) {
        let p;
        let a;
        let t_value = /*tag*/ ctx[16].title + "";
        let t;
        let a_data_slug_value;
        let a_href_value;
        let dispose;

        return {
            c() {
                p = element("p");
                a = element("a");
                t = text(t_value);
                attr(a, "data-slug", a_data_slug_value = slugify(/*tag*/ ctx[16].title));
                attr(a, "href", a_href_value = "#/rg~" + slugify(/*tag*/ ctx[16].title));
                attr(a, "class", "is-inline-block");
                attr(p, "class", "menu-label");
                dispose = listen(a, "click", /*handleTagClick*/ ctx[10]);
            },
            m(target, anchor) {
                insert(target, p, anchor);
                append(p, a);
                append(a, t);
            },
            p(ctx, dirty) {
                if (dirty & /*filteredActions*/ 8192 && t_value !== (t_value = /*tag*/ ctx[16].title + "")) set_data(t, t_value);

                if (dirty & /*filteredActions*/ 8192 && a_data_slug_value !== (a_data_slug_value = slugify(/*tag*/ ctx[16].title))) {
                    attr(a, "data-slug", a_data_slug_value);
                }

                if (dirty & /*filteredActions*/ 8192 && a_href_value !== (a_href_value = "#/rg~" + slugify(/*tag*/ ctx[16].title))) {
                    attr(a, "href", a_href_value);
                }
            },
            d(detaching) {
                if (detaching) detach(p);
                dispose();
            }
        };
    }

    // (208:8) {#each tag.children as child}
    function create_each_block_1(ctx) {
        let current;

        const menuitem = new MenuItem({
            props: {
                title: /*child*/ ctx[19].title,
                actions: /*child*/ ctx[19].actions,
                hidden: /*actionsCount*/ ctx[5] > 50,
                currentSlug: /*currentSlug*/ ctx[4],
                handleClick: /*handleClick*/ ctx[8],
                handleGroupClick: /*handleGroupClick*/ ctx[9]
            }
        });

        return {
            c() {
                create_component(menuitem.$$.fragment);
            },
            m(target, anchor) {
                mount_component(menuitem, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const menuitem_changes = {};
                if (dirty & /*filteredActions*/ 8192) menuitem_changes.title = /*child*/ ctx[19].title;
                if (dirty & /*filteredActions*/ 8192) menuitem_changes.actions = /*child*/ ctx[19].actions;
                if (dirty & /*actionsCount*/ 32) menuitem_changes.hidden = /*actionsCount*/ ctx[5] > 50;
                if (dirty & /*currentSlug*/ 16) menuitem_changes.currentSlug = /*currentSlug*/ ctx[4];
                if (dirty & /*handleClick*/ 256) menuitem_changes.handleClick = /*handleClick*/ ctx[8];
                if (dirty & /*handleGroupClick*/ 512) menuitem_changes.handleGroupClick = /*handleGroupClick*/ ctx[9];
                menuitem.$set(menuitem_changes);
            },
            i(local) {
                if (current) return;
                transition_in(menuitem.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(menuitem.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(menuitem, detaching);
            }
        };
    }

    // (194:4) {#each filteredActions as tag}
    function create_each_block$1(ctx) {
        let t0;
        let ul;
        let t1;
        let current;
        let if_block = /*tag*/ ctx[16].title && create_if_block$1(ctx);
        let each_value_1 = /*tag*/ ctx[16].children;
        let each_blocks = [];

        for (let i = 0; i < each_value_1.length; i += 1) {
            each_blocks[i] = create_each_block_1(get_each_context_1(ctx, each_value_1, i));
        }

        const out = i => transition_out(each_blocks[i], 1, 1, () => {
            each_blocks[i] = null;
        });

        return {
            c() {
                if (if_block) if_block.c();
                t0 = space();
                ul = element("ul");

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].c();
                }

                t1 = space();
                attr(ul, "class", "menu-list");
            },
            m(target, anchor) {
                if (if_block) if_block.m(target, anchor);
                insert(target, t0, anchor);
                insert(target, ul, anchor);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].m(ul, null);
                }

                append(ul, t1);
                current = true;
            },
            p(ctx, dirty) {
                if (/*tag*/ ctx[16].title) {
                    if (if_block) {
                        if_block.p(ctx, dirty);
                    } else {
                        if_block = create_if_block$1(ctx);
                        if_block.c();
                        if_block.m(t0.parentNode, t0);
                    }
                } else if (if_block) {
                    if_block.d(1);
                    if_block = null;
                }

                if (dirty & /*filteredActions, actionsCount, currentSlug, handleClick, handleGroupClick*/ 9008) {
                    each_value_1 = /*tag*/ ctx[16].children;
                    let i;

                    for (i = 0; i < each_value_1.length; i += 1) {
                        const child_ctx = get_each_context_1(ctx, each_value_1, i);

                        if (each_blocks[i]) {
                            each_blocks[i].p(child_ctx, dirty);
                            transition_in(each_blocks[i], 1);
                        } else {
                            each_blocks[i] = create_each_block_1(child_ctx);
                            each_blocks[i].c();
                            transition_in(each_blocks[i], 1);
                            each_blocks[i].m(ul, t1);
                        }
                    }

                    group_outros();

                    for (i = each_value_1.length; i < each_blocks.length; i += 1) {
                        out(i);
                    }

                    check_outros();
                }
            },
            i(local) {
                if (current) return;

                for (let i = 0; i < each_value_1.length; i += 1) {
                    transition_in(each_blocks[i]);
                }

                current = true;
            },
            o(local) {
                each_blocks = each_blocks.filter(Boolean);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    transition_out(each_blocks[i]);
                }

                current = false;
            },
            d(detaching) {
                if (if_block) if_block.d(detaching);
                if (detaching) detach(t0);
                if (detaching) detach(ul);
                destroy_each(each_blocks, detaching);
            }
        };
    }

    function create_fragment$1(ctx) {
        let aside;
        let section;
        let div1;
        let div0;
        let p0;
        let input;
        let t0;
        let span;
        let t1;
        let div2;
        let p1;
        let a;
        let t2;
        let t3;
        let t4;
        let current;
        let dispose;
        let if_block = /*query*/ ctx[0] === "" && create_if_block_1$1(ctx);
        let each_value = /*filteredActions*/ ctx[13];
        let each_blocks = [];

        for (let i = 0; i < each_value.length; i += 1) {
            each_blocks[i] = create_each_block$1(get_each_context$1(ctx, each_value, i));
        }

        const out = i => transition_out(each_blocks[i], 1, 1, () => {
            each_blocks[i] = null;
        });

        return {
            c() {
                aside = element("aside");
                section = element("section");
                div1 = element("div");
                div0 = element("div");
                p0 = element("p");
                input = element("input");
                t0 = space();
                span = element("span");
                span.innerHTML = `<i class="fas fa-search"></i>`;
                t1 = space();
                div2 = element("div");
                p1 = element("p");
                a = element("a");
                t2 = text(/*title*/ ctx[1]);
                t3 = space();
                if (if_block) if_block.c();
                t4 = space();

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].c();
                }

                attr(input, "id", "search-input-text");
                attr(input, "class", "input is-rounded svelte-fvssqr");
                attr(input, "placeholder", "Filter by path, method, and title...");
                attr(span, "class", "icon is-right icon-input-search svelte-fvssqr");
                attr(p0, "class", "control has-icons-right");
                attr(div0, "class", "field");
                attr(div1, "class", "hero-body svelte-fvssqr");
                toggle_class(div1, "is-darkmode", /*isDarkmode*/ ctx[7]);
                attr(section, "class", "hero is-sticky svelte-fvssqr");
                toggle_class(section, "is-darkmode", /*isDarkmode*/ ctx[7]);
                attr(a, "href", "/");
                attr(p1, "class", "menu-label");
                attr(div2, "class", "menu-wrapper svelte-fvssqr");
                attr(aside, "class", "menu svelte-fvssqr");
                toggle_class(aside, "is-collapsed", /*isCollapsed*/ ctx[6]);

                dispose = [
                    listen(input, "input", /*input_input_handler*/ ctx[15]),
                    listen(span, "click", /*searchClick*/ ctx[12])
                ];
            },
            m(target, anchor) {
                insert(target, aside, anchor);
                append(aside, section);
                append(section, div1);
                append(div1, div0);
                append(div0, p0);
                append(p0, input);
                set_input_value(input, /*query*/ ctx[0]);
                append(p0, t0);
                append(p0, span);
                append(aside, t1);
                append(aside, div2);
                append(div2, p1);
                append(p1, a);
                append(a, t2);
                append(div2, t3);
                if (if_block) if_block.m(div2, null);
                append(div2, t4);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].m(div2, null);
                }

                current = true;
            },
            p(ctx, [dirty]) {
                if (dirty & /*query*/ 1 && input.value !== /*query*/ ctx[0]) {
                    set_input_value(input, /*query*/ ctx[0]);
                }

                if (dirty & /*isDarkmode*/ 128) {
                    toggle_class(div1, "is-darkmode", /*isDarkmode*/ ctx[7]);
                }

                if (dirty & /*isDarkmode*/ 128) {
                    toggle_class(section, "is-darkmode", /*isDarkmode*/ ctx[7]);
                }

                if (!current || dirty & /*title*/ 2) set_data(t2, /*title*/ ctx[1]);

                if (/*query*/ ctx[0] === "") {
                    if (if_block) {
                        if_block.p(ctx, dirty);
                    } else {
                        if_block = create_if_block_1$1(ctx);
                        if_block.c();
                        if_block.m(div2, t4);
                    }
                } else if (if_block) {
                    if_block.d(1);
                    if_block = null;
                }

                if (dirty & /*filteredActions, actionsCount, currentSlug, handleClick, handleGroupClick, slugify, handleTagClick*/ 10032) {
                    each_value = /*filteredActions*/ ctx[13];
                    let i;

                    for (i = 0; i < each_value.length; i += 1) {
                        const child_ctx = get_each_context$1(ctx, each_value, i);

                        if (each_blocks[i]) {
                            each_blocks[i].p(child_ctx, dirty);
                            transition_in(each_blocks[i], 1);
                        } else {
                            each_blocks[i] = create_each_block$1(child_ctx);
                            each_blocks[i].c();
                            transition_in(each_blocks[i], 1);
                            each_blocks[i].m(div2, null);
                        }
                    }

                    group_outros();

                    for (i = each_value.length; i < each_blocks.length; i += 1) {
                        out(i);
                    }

                    check_outros();
                }

                if (dirty & /*isCollapsed*/ 64) {
                    toggle_class(aside, "is-collapsed", /*isCollapsed*/ ctx[6]);
                }
            },
            i(local) {
                if (current) return;

                for (let i = 0; i < each_value.length; i += 1) {
                    transition_in(each_blocks[i]);
                }

                current = true;
            },
            o(local) {
                each_blocks = each_blocks.filter(Boolean);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    transition_out(each_blocks[i]);
                }

                current = false;
            },
            d(detaching) {
                if (detaching) detach(aside);
                if (if_block) if_block.d();
                destroy_each(each_blocks, detaching);
                run_all(dispose);
            }
        };
    }

    function headerLink(text) {
        return text.toLowerCase().replace(/\s/g, "-");
    }

    function instance$1($$self, $$props, $$invalidate) {
        let { title } = $$props;
        let { config = {} } = $$props;
        let { tagActions = [] } = $$props;
        let { tagHeaders = [] } = $$props;
        let { currentSlug } = $$props;
        let { actionsCount } = $$props;
        let { isCollapsed } = $$props;
        let { isDarkmode } = $$props;
        let { handleClick } = $$props;
        let { handleGroupClick } = $$props;
        let { handleTagClick } = $$props;
        let { tocClick } = $$props;
        let { searchClick } = $$props;
        let { query } = $$props;

        function input_input_handler() {
            query = this.value;
            $$invalidate(0, query);
        }

        $$self.$set = $$props => {
            if ("title" in $$props) $$invalidate(1, title = $$props.title);
            if ("config" in $$props) $$invalidate(2, config = $$props.config);
            if ("tagActions" in $$props) $$invalidate(14, tagActions = $$props.tagActions);
            if ("tagHeaders" in $$props) $$invalidate(3, tagHeaders = $$props.tagHeaders);
            if ("currentSlug" in $$props) $$invalidate(4, currentSlug = $$props.currentSlug);
            if ("actionsCount" in $$props) $$invalidate(5, actionsCount = $$props.actionsCount);
            if ("isCollapsed" in $$props) $$invalidate(6, isCollapsed = $$props.isCollapsed);
            if ("isDarkmode" in $$props) $$invalidate(7, isDarkmode = $$props.isDarkmode);
            if ("handleClick" in $$props) $$invalidate(8, handleClick = $$props.handleClick);
            if ("handleGroupClick" in $$props) $$invalidate(9, handleGroupClick = $$props.handleGroupClick);
            if ("handleTagClick" in $$props) $$invalidate(10, handleTagClick = $$props.handleTagClick);
            if ("tocClick" in $$props) $$invalidate(11, tocClick = $$props.tocClick);
            if ("searchClick" in $$props) $$invalidate(12, searchClick = $$props.searchClick);
            if ("query" in $$props) $$invalidate(0, query = $$props.query);
        };

        let filteredActions;

        $$self.$$.update = () => {
            if ($$self.$$.dirty & /*tagActions, query*/ 16385) {
                $$invalidate(13, filteredActions = filterActions(tagActions, query));
            }
        };

        return [
            query,
            title,
            config,
            tagHeaders,
            currentSlug,
            actionsCount,
            isCollapsed,
            isDarkmode,
            handleClick,
            handleGroupClick,
            handleTagClick,
            tocClick,
            searchClick,
            filteredActions,
            tagActions,
            input_input_handler
        ];
    }

    class MenuPanel extends SvelteComponent {
        constructor(options) {
            super();
            if (!document.getElementById("svelte-fvssqr-style")) add_css$1();

            init(this, options, instance$1, create_fragment$1, safe_not_equal, {
                title: 1,
                config: 2,
                tagActions: 14,
                tagHeaders: 3,
                currentSlug: 4,
                actionsCount: 5,
                isCollapsed: 6,
                isDarkmode: 7,
                handleClick: 8,
                handleGroupClick: 9,
                handleTagClick: 10,
                tocClick: 11,
                searchClick: 12,
                query: 0
            });
        }
    }

    /* app/templates/winter/tables/HeaderTable.svelte generated by Svelte v3.16.5 */

    function get_each_context$2(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[1] = list[i].name;
        child_ctx[2] = list[i].example;
        return child_ctx;
    }

    // (5:0) {#if headers.length > 0}
    function create_if_block$2(ctx) {
        let table;
        let thead;
        let t1;
        let tbody;
        let each_value = /*headers*/ ctx[0];
        let each_blocks = [];

        for (let i = 0; i < each_value.length; i += 1) {
            each_blocks[i] = create_each_block$2(get_each_context$2(ctx, each_value, i));
        }

        return {
            c() {
                table = element("table");
                thead = element("thead");
                thead.innerHTML = `<tr><th colspan="2">Headers</th></tr>`;
                t1 = space();
                tbody = element("tbody");

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].c();
                }

                attr(table, "class", "table is-stripped is-fullwidth");
            },
            m(target, anchor) {
                insert(target, table, anchor);
                append(table, thead);
                append(table, t1);
                append(table, tbody);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].m(tbody, null);
                }
            },
            p(ctx, dirty) {
                if (dirty & /*headers*/ 1) {
                    each_value = /*headers*/ ctx[0];
                    let i;

                    for (i = 0; i < each_value.length; i += 1) {
                        const child_ctx = get_each_context$2(ctx, each_value, i);

                        if (each_blocks[i]) {
                            each_blocks[i].p(child_ctx, dirty);
                        } else {
                            each_blocks[i] = create_each_block$2(child_ctx);
                            each_blocks[i].c();
                            each_blocks[i].m(tbody, null);
                        }
                    }

                    for (; i < each_blocks.length; i += 1) {
                        each_blocks[i].d(1);
                    }

                    each_blocks.length = each_value.length;
                }
            },
            d(detaching) {
                if (detaching) detach(table);
                destroy_each(each_blocks, detaching);
            }
        };
    }

    // (13:6) {#each headers as { name, example }}
    function create_each_block$2(ctx) {
        let tr;
        let td0;
        let t0_value = /*name*/ ctx[1] + "";
        let t0;
        let t1;
        let td1;
        let code;
        let t2_value = /*example*/ ctx[2] + "";
        let t2;
        let t3;

        return {
            c() {
                tr = element("tr");
                td0 = element("td");
                t0 = text(t0_value);
                t1 = space();
                td1 = element("td");
                code = element("code");
                t2 = text(t2_value);
                t3 = space();
            },
            m(target, anchor) {
                insert(target, tr, anchor);
                append(tr, td0);
                append(td0, t0);
                append(tr, t1);
                append(tr, td1);
                append(td1, code);
                append(code, t2);
                append(tr, t3);
            },
            p(ctx, dirty) {
                if (dirty & /*headers*/ 1 && t0_value !== (t0_value = /*name*/ ctx[1] + "")) set_data(t0, t0_value);
                if (dirty & /*headers*/ 1 && t2_value !== (t2_value = /*example*/ ctx[2] + "")) set_data(t2, t2_value);
            },
            d(detaching) {
                if (detaching) detach(tr);
            }
        };
    }

    function create_fragment$2(ctx) {
        let if_block_anchor;
        let if_block = /*headers*/ ctx[0].length > 0 && create_if_block$2(ctx);

        return {
            c() {
                if (if_block) if_block.c();
                if_block_anchor = empty();
            },
            m(target, anchor) {
                if (if_block) if_block.m(target, anchor);
                insert(target, if_block_anchor, anchor);
            },
            p(ctx, [dirty]) {
                if (/*headers*/ ctx[0].length > 0) {
                    if (if_block) {
                        if_block.p(ctx, dirty);
                    } else {
                        if_block = create_if_block$2(ctx);
                        if_block.c();
                        if_block.m(if_block_anchor.parentNode, if_block_anchor);
                    }
                } else if (if_block) {
                    if_block.d(1);
                    if_block = null;
                }
            },
            i: noop,
            o: noop,
            d(detaching) {
                if (if_block) if_block.d(detaching);
                if (detaching) detach(if_block_anchor);
            }
        };
    }

    function instance$2($$self, $$props, $$invalidate) {
        let { headers = [] } = $$props;

        $$self.$set = $$props => {
            if ("headers" in $$props) $$invalidate(0, headers = $$props.headers);
        };

        return [headers];
    }

    class HeaderTable extends SvelteComponent {
        constructor(options) {
            super();
            init(this, options, instance$2, create_fragment$2, safe_not_equal, { headers: 0 });
        }
    }

    /* app/templates/winter/components/CodeBlock.svelte generated by Svelte v3.16.5 */

    function create_if_block$3(ctx) {
        let pre;
        let code;
        let raw_value = highlight(stringify$2(/*body*/ ctx[0]), /*mime*/ ctx[1]) + "";
        let code_class_value;
        let pre_class_value;

        return {
            c() {
                pre = element("pre");
                code = element("code");
                attr(code, "class", code_class_value = "language-" + /*mime*/ ctx[1]);
                attr(pre, "class", pre_class_value = "language-" + /*mime*/ ctx[1]);
            },
            m(target, anchor) {
                insert(target, pre, anchor);
                append(pre, code);
                code.innerHTML = raw_value;
            },
            p(ctx, dirty) {
                if (dirty & /*body, mime*/ 3 && raw_value !== (raw_value = highlight(stringify$2(/*body*/ ctx[0]), /*mime*/ ctx[1]) + "")) code.innerHTML = raw_value;;

                if (dirty & /*mime*/ 2 && code_class_value !== (code_class_value = "language-" + /*mime*/ ctx[1])) {
                    attr(code, "class", code_class_value);
                }

                if (dirty & /*mime*/ 2 && pre_class_value !== (pre_class_value = "language-" + /*mime*/ ctx[1])) {
                    attr(pre, "class", pre_class_value);
                }
            },
            d(detaching) {
                if (detaching) detach(pre);
            }
        };
    }

    function create_fragment$3(ctx) {
        let if_block_anchor;
        let if_block = /*body*/ ctx[0] && create_if_block$3(ctx);

        return {
            c() {
                if (if_block) if_block.c();
                if_block_anchor = empty();
            },
            m(target, anchor) {
                if (if_block) if_block.m(target, anchor);
                insert(target, if_block_anchor, anchor);
            },
            p(ctx, [dirty]) {
                if (/*body*/ ctx[0]) {
                    if (if_block) {
                        if_block.p(ctx, dirty);
                    } else {
                        if_block = create_if_block$3(ctx);
                        if_block.c();
                        if_block.m(if_block_anchor.parentNode, if_block_anchor);
                    }
                } else if (if_block) {
                    if_block.d(1);
                    if_block = null;
                }
            },
            i: noop,
            o: noop,
            d(detaching) {
                if (if_block) if_block.d(detaching);
                if (detaching) detach(if_block_anchor);
            }
        };
    }

    function instance$3($$self, $$props, $$invalidate) {
        let { type } = $$props;
        let { body } = $$props;

        $$self.$set = $$props => {
            if ("type" in $$props) $$invalidate(2, type = $$props.type);
            if ("body" in $$props) $$invalidate(0, body = $$props.body);
        };

        let mime;

        $$self.$$.update = () => {
            if ($$self.$$.dirty & /*type*/ 4) {
                $$invalidate(1, mime = alias(type));
            }
        };

        return [body, mime, type];
    }

    class CodeBlock extends SvelteComponent {
        constructor(options) {
            super();
            init(this, options, instance$3, create_fragment$3, safe_not_equal, { type: 2, body: 0 });
        }
    }

    /* app/templates/winter/panels/CodePanel.svelte generated by Svelte v3.16.5 */

    function add_css$2() {
        var style = element("style");
        style.id = "svelte-15v28ah-style";
        style.textContent = ".tab-content.svelte-15v28ah{display:none}.tab-content.is-active.svelte-15v28ah{display:block}";
        append(document.head, style);
    }

    // (32:0) {#if example || schema}
    function create_if_block$4(ctx) {
        let div2;
        let div0;
        let ul;
        let li0;
        let a0;
        let t1;
        let li1;
        let a1;
        let t3;
        let div1;
        let section0;
        let section0_class_value;
        let t4;
        let section1;
        let section1_class_value;
        let current;
        let dispose;

        const codeblock0 = new CodeBlock({
            props: {
                type: /*contentType*/ ctx[0],
                body: /*example*/ ctx[1]
            }
        });

        const codeblock1 = new CodeBlock({
            props: {
                type: "application/json",
                body: /*schema*/ ctx[2]
            }
        });

        return {
            c() {
                div2 = element("div");
                div0 = element("div");
                ul = element("ul");
                li0 = element("li");
                a0 = element("a");
                a0.textContent = "Body";
                t1 = space();
                li1 = element("li");
                a1 = element("a");
                a1.textContent = "Schema";
                t3 = space();
                div1 = element("div");
                section0 = element("section");
                create_component(codeblock0.$$.fragment);
                t4 = space();
                section1 = element("section");
                create_component(codeblock1.$$.fragment);
                attr(a0, "data-index", "0");
                attr(a0, "href", "javascript:void(0)");
                toggle_class(li0, "is-active", /*tabIndex*/ ctx[7] === 0);
                attr(a1, "data-index", "1");
                attr(a1, "href", "javascript:void(0)");
                toggle_class(li1, "is-active", /*tabIndex*/ ctx[7] === 1);
                attr(div0, "class", "tabs is-fullwidth");
                toggle_class(div0, "is-toggle", /*asToggle*/ ctx[3]);
                attr(section0, "class", section0_class_value = "tab-content " + /*activeBody*/ ctx[5] + " svelte-15v28ah");
                attr(section1, "class", section1_class_value = "tab-content " + /*activeSchema*/ ctx[6] + " svelte-15v28ah");
                attr(div2, "class", "tabs-with-content");

                dispose = [
                    listen(a0, "click", /*tabSelect*/ ctx[4]),
                    listen(a1, "click", /*tabSelect*/ ctx[4])
                ];
            },
            m(target, anchor) {
                insert(target, div2, anchor);
                append(div2, div0);
                append(div0, ul);
                append(ul, li0);
                append(li0, a0);
                append(ul, t1);
                append(ul, li1);
                append(li1, a1);
                append(div2, t3);
                append(div2, div1);
                append(div1, section0);
                mount_component(codeblock0, section0, null);
                append(div1, t4);
                append(div1, section1);
                mount_component(codeblock1, section1, null);
                current = true;
            },
            p(ctx, dirty) {
                if (dirty & /*tabIndex*/ 128) {
                    toggle_class(li0, "is-active", /*tabIndex*/ ctx[7] === 0);
                }

                if (dirty & /*tabIndex*/ 128) {
                    toggle_class(li1, "is-active", /*tabIndex*/ ctx[7] === 1);
                }

                if (dirty & /*asToggle*/ 8) {
                    toggle_class(div0, "is-toggle", /*asToggle*/ ctx[3]);
                }

                const codeblock0_changes = {};
                if (dirty & /*contentType*/ 1) codeblock0_changes.type = /*contentType*/ ctx[0];
                if (dirty & /*example*/ 2) codeblock0_changes.body = /*example*/ ctx[1];
                codeblock0.$set(codeblock0_changes);

                if (!current || dirty & /*activeBody*/ 32 && section0_class_value !== (section0_class_value = "tab-content " + /*activeBody*/ ctx[5] + " svelte-15v28ah")) {
                    attr(section0, "class", section0_class_value);
                }

                const codeblock1_changes = {};
                if (dirty & /*schema*/ 4) codeblock1_changes.body = /*schema*/ ctx[2];
                codeblock1.$set(codeblock1_changes);

                if (!current || dirty & /*activeSchema*/ 64 && section1_class_value !== (section1_class_value = "tab-content " + /*activeSchema*/ ctx[6] + " svelte-15v28ah")) {
                    attr(section1, "class", section1_class_value);
                }
            },
            i(local) {
                if (current) return;
                transition_in(codeblock0.$$.fragment, local);
                transition_in(codeblock1.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(codeblock0.$$.fragment, local);
                transition_out(codeblock1.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                if (detaching) detach(div2);
                destroy_component(codeblock0);
                destroy_component(codeblock1);
                run_all(dispose);
            }
        };
    }

    function create_fragment$4(ctx) {
        let if_block_anchor;
        let current;
        let if_block = (/*example*/ ctx[1] || /*schema*/ ctx[2]) && create_if_block$4(ctx);

        return {
            c() {
                if (if_block) if_block.c();
                if_block_anchor = empty();
            },
            m(target, anchor) {
                if (if_block) if_block.m(target, anchor);
                insert(target, if_block_anchor, anchor);
                current = true;
            },
            p(ctx, [dirty]) {
                if (/*example*/ ctx[1] || /*schema*/ ctx[2]) {
                    if (if_block) {
                        if_block.p(ctx, dirty);
                        transition_in(if_block, 1);
                    } else {
                        if_block = create_if_block$4(ctx);
                        if_block.c();
                        transition_in(if_block, 1);
                        if_block.m(if_block_anchor.parentNode, if_block_anchor);
                    }
                } else if (if_block) {
                    group_outros();

                    transition_out(if_block, 1, 1, () => {
                        if_block = null;
                    });

                    check_outros();
                }
            },
            i(local) {
                if (current) return;
                transition_in(if_block);
                current = true;
            },
            o(local) {
                transition_out(if_block);
                current = false;
            },
            d(detaching) {
                if (if_block) if_block.d(detaching);
                if (detaching) detach(if_block_anchor);
            }
        };
    }

    function instance$4($$self, $$props, $$invalidate) {
        let { contentType } = $$props;
        let { example } = $$props;
        let { schema } = $$props;
        let { asToggle } = $$props;
        let activeBody = "is-active";
        let activeSchema = "";
        let tabIndex = 0;

        const tabSelect = event => {
            const index = event.target.dataset["index"];
            $$invalidate(7, tabIndex = parseInt(index, 10));
        };

        $$self.$set = $$props => {
            if ("contentType" in $$props) $$invalidate(0, contentType = $$props.contentType);
            if ("example" in $$props) $$invalidate(1, example = $$props.example);
            if ("schema" in $$props) $$invalidate(2, schema = $$props.schema);
            if ("asToggle" in $$props) $$invalidate(3, asToggle = $$props.asToggle);
        };

        $$self.$$.update = () => {
            if ($$self.$$.dirty & /*tabIndex*/ 128) {
                $$invalidate(5, activeBody = tabIndex === 0 ? "is-active" : "");
            }

            if ($$self.$$.dirty & /*tabIndex*/ 128) {
                $$invalidate(6, activeSchema = tabIndex === 1 ? "is-active" : "");
            }
        };

        return [
            contentType,
            example,
            schema,
            asToggle,
            tabSelect,
            activeBody,
            activeSchema,
            tabIndex
        ];
    }

    class CodePanel extends SvelteComponent {
        constructor(options) {
            super();
            if (!document.getElementById("svelte-15v28ah-style")) add_css$2();

            init(this, options, instance$4, create_fragment$4, safe_not_equal, {
                contentType: 0,
                example: 1,
                schema: 2,
                asToggle: 3,
                tabSelect: 4
            });
        }

        get tabSelect() {
            return this.$$.ctx[4];
        }
    }

    /* app/templates/winter/panels/RequestPanel.svelte generated by Svelte v3.16.5 */

    function create_if_block_1$2(ctx) {
        let div;
        let raw_value = markdown(/*description*/ ctx[0]) + "";

        return {
            c() {
                div = element("div");
                attr(div, "class", "content");
            },
            m(target, anchor) {
                insert(target, div, anchor);
                div.innerHTML = raw_value;
            },
            p(ctx, dirty) {
                if (dirty & /*description*/ 1 && raw_value !== (raw_value = markdown(/*description*/ ctx[0]) + "")) div.innerHTML = raw_value;;
            },
            d(detaching) {
                if (detaching) detach(div);
            }
        };
    }

    // (26:0) {#if showRequest}
    function create_if_block$5(ctx) {
        let hr;

        return {
            c() {
                hr = element("hr");
            },
            m(target, anchor) {
                insert(target, hr, anchor);
            },
            d(detaching) {
                if (detaching) detach(hr);
            }
        };
    }

    function create_fragment$5(ctx) {
        let t0;
        let t1;
        let t2;
        let if_block1_anchor;
        let current;
        let if_block0 = /*description*/ ctx[0] && create_if_block_1$2(ctx);
        const headertable = new HeaderTable({ props: { headers: /*headers*/ ctx[1] } });

        const codepanel = new CodePanel({
            props: {
                contentType: /*contentType*/ ctx[2],
                example: /*example*/ ctx[3],
                schema: /*schema*/ ctx[4],
                asToggle: true
            }
        });

        let if_block1 = /*showRequest*/ ctx[5] && create_if_block$5(ctx);

        return {
            c() {
                if (if_block0) if_block0.c();
                t0 = space();
                create_component(headertable.$$.fragment);
                t1 = space();
                create_component(codepanel.$$.fragment);
                t2 = space();
                if (if_block1) if_block1.c();
                if_block1_anchor = empty();
            },
            m(target, anchor) {
                if (if_block0) if_block0.m(target, anchor);
                insert(target, t0, anchor);
                mount_component(headertable, target, anchor);
                insert(target, t1, anchor);
                mount_component(codepanel, target, anchor);
                insert(target, t2, anchor);
                if (if_block1) if_block1.m(target, anchor);
                insert(target, if_block1_anchor, anchor);
                current = true;
            },
            p(ctx, [dirty]) {
                if (/*description*/ ctx[0]) {
                    if (if_block0) {
                        if_block0.p(ctx, dirty);
                    } else {
                        if_block0 = create_if_block_1$2(ctx);
                        if_block0.c();
                        if_block0.m(t0.parentNode, t0);
                    }
                } else if (if_block0) {
                    if_block0.d(1);
                    if_block0 = null;
                }

                const headertable_changes = {};
                if (dirty & /*headers*/ 2) headertable_changes.headers = /*headers*/ ctx[1];
                headertable.$set(headertable_changes);
                const codepanel_changes = {};
                if (dirty & /*contentType*/ 4) codepanel_changes.contentType = /*contentType*/ ctx[2];
                if (dirty & /*example*/ 8) codepanel_changes.example = /*example*/ ctx[3];
                if (dirty & /*schema*/ 16) codepanel_changes.schema = /*schema*/ ctx[4];
                codepanel.$set(codepanel_changes);

                if (/*showRequest*/ ctx[5]) {
                    if (!if_block1) {
                        if_block1 = create_if_block$5(ctx);
                        if_block1.c();
                        if_block1.m(if_block1_anchor.parentNode, if_block1_anchor);
                    } else {

                    }
                } else if (if_block1) {
                    if_block1.d(1);
                    if_block1 = null;
                }
            },
            i(local) {
                if (current) return;
                transition_in(headertable.$$.fragment, local);
                transition_in(codepanel.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(headertable.$$.fragment, local);
                transition_out(codepanel.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                if (if_block0) if_block0.d(detaching);
                if (detaching) detach(t0);
                destroy_component(headertable, detaching);
                if (detaching) detach(t1);
                destroy_component(codepanel, detaching);
                if (detaching) detach(t2);
                if (if_block1) if_block1.d(detaching);
                if (detaching) detach(if_block1_anchor);
            }
        };
    }

    function instance$5($$self, $$props, $$invalidate) {
        let { description } = $$props;
        let { headers } = $$props;
        let { contentType } = $$props;
        let { example } = $$props;
        let { schema } = $$props;

        $$self.$set = $$props => {
            if ("description" in $$props) $$invalidate(0, description = $$props.description);
            if ("headers" in $$props) $$invalidate(1, headers = $$props.headers);
            if ("contentType" in $$props) $$invalidate(2, contentType = $$props.contentType);
            if ("example" in $$props) $$invalidate(3, example = $$props.example);
            if ("schema" in $$props) $$invalidate(4, schema = $$props.schema);
        };

        let showRequest;

        $$self.$$.update = () => {
            if ($$self.$$.dirty & /*description, headers, example*/ 11) {
                $$invalidate(5, showRequest = !!(description || headers.length !== 0 || example));
            }
        };

        return [description, headers, contentType, example, schema, showRequest];
    }

    class RequestPanel extends SvelteComponent {
        constructor(options) {
            super();

            init(this, options, instance$5, create_fragment$5, safe_not_equal, {
                description: 0,
                headers: 1,
                contentType: 2,
                example: 3,
                schema: 4
            });
        }
    }

    /* app/templates/winter/panels/ResponsePanel.svelte generated by Svelte v3.16.5 */

    function create_else_block(ctx) {
        let t_value = (/*contentType*/ ctx[4] || "Response") + "";
        let t;

        return {
            c() {
                t = text(t_value);
            },
            m(target, anchor) {
                insert(target, t, anchor);
            },
            p(ctx, dirty) {
                if (dirty & /*contentType*/ 16 && t_value !== (t_value = (/*contentType*/ ctx[4] || "Response") + "")) set_data(t, t_value);
            },
            d(detaching) {
                if (detaching) detach(t);
            }
        };
    }

    // (19:6) {#if title}
    function create_if_block_2$1(ctx) {
        let t0;
        let t1;

        return {
            c() {
                t0 = text("Response ");
                t1 = text(/*title*/ ctx[0]);
            },
            m(target, anchor) {
                insert(target, t0, anchor);
                insert(target, t1, anchor);
            },
            p(ctx, dirty) {
                if (dirty & /*title*/ 1) set_data(t1, /*title*/ ctx[0]);
            },
            d(detaching) {
                if (detaching) detach(t0);
                if (detaching) detach(t1);
            }
        };
    }

    // (23:6) {#if title !== ''}
    function create_if_block_1$3(ctx) {
        let span;
        let t_value = (/*contentType*/ ctx[4] || "") + "";
        let t;

        return {
            c() {
                span = element("span");
                t = text(t_value);
                attr(span, "class", "tag is-medium is-white");
            },
            m(target, anchor) {
                insert(target, span, anchor);
                append(span, t);
            },
            p(ctx, dirty) {
                if (dirty & /*contentType*/ 16 && t_value !== (t_value = (/*contentType*/ ctx[4] || "") + "")) set_data(t, t_value);
            },
            d(detaching) {
                if (detaching) detach(span);
            }
        };
    }

    // (30:4) {#if description}
    function create_if_block$6(ctx) {
        let div;
        let raw_value = markdown(/*description*/ ctx[1]) + "";

        return {
            c() {
                div = element("div");
                attr(div, "class", "content");
            },
            m(target, anchor) {
                insert(target, div, anchor);
                div.innerHTML = raw_value;
            },
            p(ctx, dirty) {
                if (dirty & /*description*/ 2 && raw_value !== (raw_value = markdown(/*description*/ ctx[1]) + "")) div.innerHTML = raw_value;;
            },
            d(detaching) {
                if (detaching) detach(div);
            }
        };
    }

    function create_fragment$6(ctx) {
        let div1;
        let header;
        let p;
        let t0;
        let a;
        let t1;
        let code;
        let t2;
        let code_class_value;
        let t3;
        let div0;
        let t4;
        let t5;
        let current;

        function select_block_type(ctx, dirty) {
            if (/*title*/ ctx[0]) return create_if_block_2$1;
            return create_else_block;
        }

        let current_block_type = select_block_type(ctx, -1);
        let if_block0 = current_block_type(ctx);
        let if_block1 = /*title*/ ctx[0] !== "" && create_if_block_1$3(ctx);
        let if_block2 = /*description*/ ctx[1] && create_if_block$6(ctx);
        const headertable = new HeaderTable({ props: { headers: /*headers*/ ctx[2] } });

        const codepanel = new CodePanel({
            props: {
                contentType: /*contentType*/ ctx[4],
                example: /*example*/ ctx[5],
                schema: /*schema*/ ctx[6]
            }
        });

        return {
            c() {
                div1 = element("div");
                header = element("header");
                p = element("p");
                if_block0.c();
                t0 = space();
                a = element("a");
                if (if_block1) if_block1.c();
                t1 = space();
                code = element("code");
                t2 = text(/*statusCode*/ ctx[3]);
                t3 = space();
                div0 = element("div");
                if (if_block2) if_block2.c();
                t4 = space();
                create_component(headertable.$$.fragment);
                t5 = space();
                create_component(codepanel.$$.fragment);
                attr(p, "class", "card-header-title");
                attr(code, "class", code_class_value = "tag is-medium " + colorize(/*statusCode*/ ctx[3]));
                attr(a, "href", "javascript:void(0)");
                attr(a, "class", "card-header-icon is-family-code");
                attr(header, "class", "card-header");
                attr(div0, "class", "card-content");
                attr(div1, "class", "card");
            },
            m(target, anchor) {
                insert(target, div1, anchor);
                append(div1, header);
                append(header, p);
                if_block0.m(p, null);
                append(header, t0);
                append(header, a);
                if (if_block1) if_block1.m(a, null);
                append(a, t1);
                append(a, code);
                append(code, t2);
                append(div1, t3);
                append(div1, div0);
                if (if_block2) if_block2.m(div0, null);
                append(div0, t4);
                mount_component(headertable, div0, null);
                append(div0, t5);
                mount_component(codepanel, div0, null);
                current = true;
            },
            p(ctx, [dirty]) {
                if (current_block_type === (current_block_type = select_block_type(ctx, dirty)) && if_block0) {
                    if_block0.p(ctx, dirty);
                } else {
                    if_block0.d(1);
                    if_block0 = current_block_type(ctx);

                    if (if_block0) {
                        if_block0.c();
                        if_block0.m(p, null);
                    }
                }

                if (/*title*/ ctx[0] !== "") {
                    if (if_block1) {
                        if_block1.p(ctx, dirty);
                    } else {
                        if_block1 = create_if_block_1$3(ctx);
                        if_block1.c();
                        if_block1.m(a, t1);
                    }
                } else if (if_block1) {
                    if_block1.d(1);
                    if_block1 = null;
                }

                if (!current || dirty & /*statusCode*/ 8) set_data(t2, /*statusCode*/ ctx[3]);

                if (!current || dirty & /*statusCode*/ 8 && code_class_value !== (code_class_value = "tag is-medium " + colorize(/*statusCode*/ ctx[3]))) {
                    attr(code, "class", code_class_value);
                }

                if (/*description*/ ctx[1]) {
                    if (if_block2) {
                        if_block2.p(ctx, dirty);
                    } else {
                        if_block2 = create_if_block$6(ctx);
                        if_block2.c();
                        if_block2.m(div0, t4);
                    }
                } else if (if_block2) {
                    if_block2.d(1);
                    if_block2 = null;
                }

                const headertable_changes = {};
                if (dirty & /*headers*/ 4) headertable_changes.headers = /*headers*/ ctx[2];
                headertable.$set(headertable_changes);
                const codepanel_changes = {};
                if (dirty & /*contentType*/ 16) codepanel_changes.contentType = /*contentType*/ ctx[4];
                if (dirty & /*example*/ 32) codepanel_changes.example = /*example*/ ctx[5];
                if (dirty & /*schema*/ 64) codepanel_changes.schema = /*schema*/ ctx[6];
                codepanel.$set(codepanel_changes);
            },
            i(local) {
                if (current) return;
                transition_in(headertable.$$.fragment, local);
                transition_in(codepanel.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(headertable.$$.fragment, local);
                transition_out(codepanel.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                if (detaching) detach(div1);
                if_block0.d();
                if (if_block1) if_block1.d();
                if (if_block2) if_block2.d();
                destroy_component(headertable);
                destroy_component(codepanel);
            }
        };
    }

    function instance$6($$self, $$props, $$invalidate) {
        let { title } = $$props;
        let { description } = $$props;
        let { headers } = $$props;
        let { statusCode } = $$props;
        let { contentType } = $$props;
        let { example } = $$props;
        let { schema } = $$props;

        $$self.$set = $$props => {
            if ("title" in $$props) $$invalidate(0, title = $$props.title);
            if ("description" in $$props) $$invalidate(1, description = $$props.description);
            if ("headers" in $$props) $$invalidate(2, headers = $$props.headers);
            if ("statusCode" in $$props) $$invalidate(3, statusCode = $$props.statusCode);
            if ("contentType" in $$props) $$invalidate(4, contentType = $$props.contentType);
            if ("example" in $$props) $$invalidate(5, example = $$props.example);
            if ("schema" in $$props) $$invalidate(6, schema = $$props.schema);
        };

        return [title, description, headers, statusCode, contentType, example, schema];
    }

    class ResponsePanel extends SvelteComponent {
        constructor(options) {
            super();

            init(this, options, instance$6, create_fragment$6, safe_not_equal, {
                title: 0,
                description: 1,
                headers: 2,
                statusCode: 3,
                contentType: 4,
                example: 5,
                schema: 6
            });
        }
    }

    /* app/templates/winter/tables/ParameterTable.svelte generated by Svelte v3.16.5 */

    function get_each_context$3(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[2] = list[i].name;
        child_ctx[3] = list[i].example;
        child_ctx[4] = list[i].required;
        child_ctx[5] = list[i].description;
        child_ctx[6] = list[i].schema;
        return child_ctx;
    }

    // (36:10) {:else}
    function create_else_block$1(ctx) {
        let div;

        return {
            c() {
                div = element("div");
                div.textContent = "-";
                attr(div, "class", "content");
            },
            m(target, anchor) {
                insert(target, div, anchor);
            },
            p: noop,
            d(detaching) {
                if (detaching) detach(div);
            }
        };
    }

    // (32:10) {#if description}
    function create_if_block_2$2(ctx) {
        let div;
        let raw_value = markdown(/*description*/ ctx[5]) + "";

        return {
            c() {
                div = element("div");
                attr(div, "class", "content");
            },
            m(target, anchor) {
                insert(target, div, anchor);
                div.innerHTML = raw_value;
            },
            p(ctx, dirty) {
                if (dirty & /*parameters*/ 2 && raw_value !== (raw_value = markdown(/*description*/ ctx[5]) + "")) div.innerHTML = raw_value;;
            },
            d(detaching) {
                if (detaching) detach(div);
            }
        };
    }

    // (40:10) {#if example}
    function create_if_block_1$4(ctx) {
        let div;
        let span;
        let t1;
        let code;
        let t2_value = /*example*/ ctx[3] + "";
        let t2;

        return {
            c() {
                div = element("div");
                span = element("span");
                span.textContent = "Example:";
                t1 = space();
                code = element("code");
                t2 = text(t2_value);
                attr(code, "class", "tag");
            },
            m(target, anchor) {
                insert(target, div, anchor);
                append(div, span);
                append(div, t1);
                append(div, code);
                append(code, t2);
            },
            p(ctx, dirty) {
                if (dirty & /*parameters*/ 2 && t2_value !== (t2_value = /*example*/ ctx[3] + "")) set_data(t2, t2_value);
            },
            d(detaching) {
                if (detaching) detach(div);
            }
        };
    }

    // (47:10) {#if schema.enum}
    function create_if_block$7(ctx) {
        let div;
        let span;
        let t1;
        let code;
        let t2_value = /*schema*/ ctx[6].enum + "";
        let t2;

        return {
            c() {
                div = element("div");
                span = element("span");
                span.textContent = "Values:";
                t1 = space();
                code = element("code");
                t2 = text(t2_value);
            },
            m(target, anchor) {
                insert(target, div, anchor);
                append(div, span);
                append(div, t1);
                append(div, code);
                append(code, t2);
            },
            p(ctx, dirty) {
                if (dirty & /*parameters*/ 2 && t2_value !== (t2_value = /*schema*/ ctx[6].enum + "")) set_data(t2, t2_value);
            },
            d(detaching) {
                if (detaching) detach(div);
            }
        };
    }

    // (15:4) {#each parameters as { name, example, required, description, schema }}
    function create_each_block$3(ctx) {
        let tr;
        let td0;
        let code;
        let t0_value = /*name*/ ctx[2] + "";
        let t0;
        let t1;
        let td1;
        let div;
        let span0;
        let t2_value = /*schema*/ ctx[6].type + "";
        let t2;
        let t3;
        let span1;
        let t4_value = (/*required*/ ctx[4] ? "required" : "optional") + "";
        let t4;
        let t5;
        let td2;
        let t6;
        let t7;
        let t8;

        function select_block_type(ctx, dirty) {
            if (/*description*/ ctx[5]) return create_if_block_2$2;
            return create_else_block$1;
        }

        let current_block_type = select_block_type(ctx, -1);
        let if_block0 = current_block_type(ctx);
        let if_block1 = /*example*/ ctx[3] && create_if_block_1$4(ctx);
        let if_block2 = /*schema*/ ctx[6].enum && create_if_block$7(ctx);

        return {
            c() {
                tr = element("tr");
                td0 = element("td");
                code = element("code");
                t0 = text(t0_value);
                t1 = space();
                td1 = element("td");
                div = element("div");
                span0 = element("span");
                t2 = text(t2_value);
                t3 = space();
                span1 = element("span");
                t4 = text(t4_value);
                t5 = space();
                td2 = element("td");
                if_block0.c();
                t6 = space();
                if (if_block1) if_block1.c();
                t7 = space();
                if (if_block2) if_block2.c();
                t8 = space();
                attr(span0, "class", "tag");
                attr(span1, "class", "tag");
                toggle_class(span1, "is-dark", /*required*/ ctx[4]);
                toggle_class(span1, "is-white", !/*required*/ ctx[4]);
                attr(div, "class", "tags has-addons");
            },
            m(target, anchor) {
                insert(target, tr, anchor);
                append(tr, td0);
                append(td0, code);
                append(code, t0);
                append(tr, t1);
                append(tr, td1);
                append(td1, div);
                append(div, span0);
                append(span0, t2);
                append(div, t3);
                append(div, span1);
                append(span1, t4);
                append(tr, t5);
                append(tr, td2);
                if_block0.m(td2, null);
                append(td2, t6);
                if (if_block1) if_block1.m(td2, null);
                append(td2, t7);
                if (if_block2) if_block2.m(td2, null);
                append(tr, t8);
            },
            p(ctx, dirty) {
                if (dirty & /*parameters*/ 2 && t0_value !== (t0_value = /*name*/ ctx[2] + "")) set_data(t0, t0_value);
                if (dirty & /*parameters*/ 2 && t2_value !== (t2_value = /*schema*/ ctx[6].type + "")) set_data(t2, t2_value);
                if (dirty & /*parameters*/ 2 && t4_value !== (t4_value = (/*required*/ ctx[4] ? "required" : "optional") + "")) set_data(t4, t4_value);

                if (dirty & /*parameters*/ 2) {
                    toggle_class(span1, "is-dark", /*required*/ ctx[4]);
                }

                if (dirty & /*parameters*/ 2) {
                    toggle_class(span1, "is-white", !/*required*/ ctx[4]);
                }

                if (current_block_type === (current_block_type = select_block_type(ctx, dirty)) && if_block0) {
                    if_block0.p(ctx, dirty);
                } else {
                    if_block0.d(1);
                    if_block0 = current_block_type(ctx);

                    if (if_block0) {
                        if_block0.c();
                        if_block0.m(td2, t6);
                    }
                }

                if (/*example*/ ctx[3]) {
                    if (if_block1) {
                        if_block1.p(ctx, dirty);
                    } else {
                        if_block1 = create_if_block_1$4(ctx);
                        if_block1.c();
                        if_block1.m(td2, t7);
                    }
                } else if (if_block1) {
                    if_block1.d(1);
                    if_block1 = null;
                }

                if (/*schema*/ ctx[6].enum) {
                    if (if_block2) {
                        if_block2.p(ctx, dirty);
                    } else {
                        if_block2 = create_if_block$7(ctx);
                        if_block2.c();
                        if_block2.m(td2, null);
                    }
                } else if (if_block2) {
                    if_block2.d(1);
                    if_block2 = null;
                }
            },
            d(detaching) {
                if (detaching) detach(tr);
                if_block0.d();
                if (if_block1) if_block1.d();
                if (if_block2) if_block2.d();
            }
        };
    }

    function create_fragment$7(ctx) {
        let table;
        let thead;
        let tr;
        let th;
        let t0;
        let t1;
        let tbody;
        let each_value = /*parameters*/ ctx[1];
        let each_blocks = [];

        for (let i = 0; i < each_value.length; i += 1) {
            each_blocks[i] = create_each_block$3(get_each_context$3(ctx, each_value, i));
        }

        return {
            c() {
                table = element("table");
                thead = element("thead");
                tr = element("tr");
                th = element("th");
                t0 = text(/*title*/ ctx[0]);
                t1 = space();
                tbody = element("tbody");

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].c();
                }

                attr(th, "colspan", "3");
                attr(table, "class", "table table-bordered is-bordered is-fullwidth");
            },
            m(target, anchor) {
                insert(target, table, anchor);
                append(table, thead);
                append(thead, tr);
                append(tr, th);
                append(th, t0);
                append(table, t1);
                append(table, tbody);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].m(tbody, null);
                }
            },
            p(ctx, [dirty]) {
                if (dirty & /*title*/ 1) set_data(t0, /*title*/ ctx[0]);

                if (dirty & /*parameters, markdown*/ 2) {
                    each_value = /*parameters*/ ctx[1];
                    let i;

                    for (i = 0; i < each_value.length; i += 1) {
                        const child_ctx = get_each_context$3(ctx, each_value, i);

                        if (each_blocks[i]) {
                            each_blocks[i].p(child_ctx, dirty);
                        } else {
                            each_blocks[i] = create_each_block$3(child_ctx);
                            each_blocks[i].c();
                            each_blocks[i].m(tbody, null);
                        }
                    }

                    for (; i < each_blocks.length; i += 1) {
                        each_blocks[i].d(1);
                    }

                    each_blocks.length = each_value.length;
                }
            },
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(table);
                destroy_each(each_blocks, detaching);
            }
        };
    }

    function instance$7($$self, $$props, $$invalidate) {
        let { title } = $$props;
        let { parameters } = $$props;

        $$self.$set = $$props => {
            if ("title" in $$props) $$invalidate(0, title = $$props.title);
            if ("parameters" in $$props) $$invalidate(1, parameters = $$props.parameters);
        };

        return [title, parameters];
    }

    class ParameterTable extends SvelteComponent {
        constructor(options) {
            super();
            init(this, options, instance$7, create_fragment$7, safe_not_equal, { title: 0, parameters: 1 });
        }
    }

    /* app/templates/winter/panels/ParameterPanel.svelte generated by Svelte v3.16.5 */

    function create_if_block_1$5(ctx) {
        let current;

        const parametertable = new ParameterTable({
            props: {
                parameters: /*pathParameters*/ ctx[0],
                title: "Path Parameters"
            }
        });

        return {
            c() {
                create_component(parametertable.$$.fragment);
            },
            m(target, anchor) {
                mount_component(parametertable, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const parametertable_changes = {};
                if (dirty & /*pathParameters*/ 1) parametertable_changes.parameters = /*pathParameters*/ ctx[0];
                parametertable.$set(parametertable_changes);
            },
            i(local) {
                if (current) return;
                transition_in(parametertable.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(parametertable.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(parametertable, detaching);
            }
        };
    }

    // (14:0) {#if queryParameters.length > 0}
    function create_if_block$8(ctx) {
        let current;

        const parametertable = new ParameterTable({
            props: {
                parameters: /*queryParameters*/ ctx[1],
                title: "Query Parameters"
            }
        });

        return {
            c() {
                create_component(parametertable.$$.fragment);
            },
            m(target, anchor) {
                mount_component(parametertable, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const parametertable_changes = {};
                if (dirty & /*queryParameters*/ 2) parametertable_changes.parameters = /*queryParameters*/ ctx[1];
                parametertable.$set(parametertable_changes);
            },
            i(local) {
                if (current) return;
                transition_in(parametertable.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(parametertable.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(parametertable, detaching);
            }
        };
    }

    function create_fragment$8(ctx) {
        let t;
        let if_block1_anchor;
        let current;
        let if_block0 = /*pathParameters*/ ctx[0].length > 0 && create_if_block_1$5(ctx);
        let if_block1 = /*queryParameters*/ ctx[1].length > 0 && create_if_block$8(ctx);

        return {
            c() {
                if (if_block0) if_block0.c();
                t = space();
                if (if_block1) if_block1.c();
                if_block1_anchor = empty();
            },
            m(target, anchor) {
                if (if_block0) if_block0.m(target, anchor);
                insert(target, t, anchor);
                if (if_block1) if_block1.m(target, anchor);
                insert(target, if_block1_anchor, anchor);
                current = true;
            },
            p(ctx, [dirty]) {
                if (/*pathParameters*/ ctx[0].length > 0) {
                    if (if_block0) {
                        if_block0.p(ctx, dirty);
                        transition_in(if_block0, 1);
                    } else {
                        if_block0 = create_if_block_1$5(ctx);
                        if_block0.c();
                        transition_in(if_block0, 1);
                        if_block0.m(t.parentNode, t);
                    }
                } else if (if_block0) {
                    group_outros();

                    transition_out(if_block0, 1, 1, () => {
                        if_block0 = null;
                    });

                    check_outros();
                }

                if (/*queryParameters*/ ctx[1].length > 0) {
                    if (if_block1) {
                        if_block1.p(ctx, dirty);
                        transition_in(if_block1, 1);
                    } else {
                        if_block1 = create_if_block$8(ctx);
                        if_block1.c();
                        transition_in(if_block1, 1);
                        if_block1.m(if_block1_anchor.parentNode, if_block1_anchor);
                    }
                } else if (if_block1) {
                    group_outros();

                    transition_out(if_block1, 1, 1, () => {
                        if_block1 = null;
                    });

                    check_outros();
                }
            },
            i(local) {
                if (current) return;
                transition_in(if_block0);
                transition_in(if_block1);
                current = true;
            },
            o(local) {
                transition_out(if_block0);
                transition_out(if_block1);
                current = false;
            },
            d(detaching) {
                if (if_block0) if_block0.d(detaching);
                if (detaching) detach(t);
                if (if_block1) if_block1.d(detaching);
                if (detaching) detach(if_block1_anchor);
            }
        };
    }

    function instance$8($$self, $$props, $$invalidate) {
        let { parameters = [] } = $$props;

        $$self.$set = $$props => {
            if ("parameters" in $$props) $$invalidate(2, parameters = $$props.parameters);
        };

        let pathParameters;
        let queryParameters;

        $$self.$$.update = () => {
            if ($$self.$$.dirty & /*parameters*/ 4) {
                $$invalidate(0, pathParameters = parameters.filter(param => param.location === "path"));
            }

            if ($$self.$$.dirty & /*parameters*/ 4) {
                $$invalidate(1, queryParameters = parameters.filter(param => param.location === "query"));
            }
        };

        return [pathParameters, queryParameters, parameters];
    }

    class ParameterPanel extends SvelteComponent {
        constructor(options) {
            super();
            init(this, options, instance$8, create_fragment$8, safe_not_equal, { parameters: 2 });
        }
    }

    /* app/templates/winter/components/LoginButton.svelte generated by Svelte v3.16.5 */

    function create_fragment$9(ctx) {
        let a;
        let span0;
        let t0;
        let span1;

        return {
            c() {
                a = element("a");
                span0 = element("span");
                span0.innerHTML = `<i class="fas fa-sign-in-alt" aria-hidden="true"></i>`;
                t0 = space();
                span1 = element("span");
                span1.textContent = "Login";
                attr(span0, "class", "icon");
                attr(a, "href", /*authorizeUrl*/ ctx[1]);
                attr(a, "class", "button is-dark is-rounded");
                toggle_class(a, "is-fullwidth", /*fullWidth*/ ctx[0]);
            },
            m(target, anchor) {
                insert(target, a, anchor);
                append(a, span0);
                append(a, t0);
                append(a, span1);
            },
            p(ctx, [dirty]) {
                if (dirty & /*authorizeUrl*/ 2) {
                    attr(a, "href", /*authorizeUrl*/ ctx[1]);
                }

                if (dirty & /*fullWidth*/ 1) {
                    toggle_class(a, "is-fullwidth", /*fullWidth*/ ctx[0]);
                }
            },
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(a);
            }
        };
    }

    function instance$9($$self, $$props, $$invalidate) {
        let { authOptions } = $$props;
        let { fullWidth } = $$props;
        let { pkceChallenge } = $$props;
        let { isPKCE } = $$props;

        $$self.$set = $$props => {
            if ("authOptions" in $$props) $$invalidate(2, authOptions = $$props.authOptions);
            if ("fullWidth" in $$props) $$invalidate(0, fullWidth = $$props.fullWidth);
            if ("pkceChallenge" in $$props) $$invalidate(3, pkceChallenge = $$props.pkceChallenge);
            if ("isPKCE" in $$props) $$invalidate(4, isPKCE = $$props.isPKCE);
        };

        let authorizeParams;
        let authorizeUrl;

        $$self.$$.update = () => {
            if ($$self.$$.dirty & /*isPKCE, authOptions, pkceChallenge*/ 28) {
                $$invalidate(5, authorizeParams = isPKCE
                    ? querystringify_1.stringify(
                        {
                            client_id: authOptions.clientId,
                            redirect_uri: authOptions.callbackUrl,
                            response_type: "code",
                            scope: authOptions.scopes || "",
                            code_challenge: pkceChallenge.code_challenge,
                            code_challenge_method: "S256"
                        },
                        true
                    )
                    : querystringify_1.stringify(
                        {
                            client_id: authOptions.clientId,
                            redirect_uri: authOptions.callbackUrl,
                            response_type: "code",
                            scope: authOptions.scopes || ""
                        },
                        true
                    ));
            }

            if ($$self.$$.dirty & /*authOptions, authorizeParams*/ 36) {
                $$invalidate(1, authorizeUrl = `${authOptions.authorizeUrl}${authorizeParams}`);
            }
        };

        return [fullWidth, authorizeUrl, authOptions, pkceChallenge, isPKCE];
    }

    class LoginButton extends SvelteComponent {
        constructor(options) {
            super();

            init(this, options, instance$9, create_fragment$9, safe_not_equal, {
                authOptions: 2,
                fullWidth: 0,
                pkceChallenge: 3,
                isPKCE: 4
            });
        }
    }

    /* app/templates/winter/components/LogoutButton.svelte generated by Svelte v3.16.5 */

    function create_fragment$a(ctx) {
        let a;
        let dispose;

        return {
            c() {
                a = element("a");

                a.innerHTML = `<span class="icon has-text-grey"><i class="fas fa-sign-out-alt" aria-hidden="true"></i></span>
  <span>Logout</span>`;

                attr(a, "href", "javascript:void(0)");
                attr(a, "class", "button is-light");
                dispose = listen(a, "click", /*handleClick*/ ctx[0]);
            },
            m(target, anchor) {
                insert(target, a, anchor);
            },
            p: noop,
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(a);
                dispose();
            }
        };
    }

    function instance$a($$self, $$props, $$invalidate) {
        let $env;
        component_subscribe($$self, env, $$value => $$invalidate(1, $env = $$value));

        function handleClick() {
            auth.remove($env);
            removeToken($env);
            removeRefreshToken($env);
        }

        return [handleClick];
    }

    class LogoutButton extends SvelteComponent {
        constructor(options) {
            super();
            init(this, options, instance$a, create_fragment$a, safe_not_equal, {});
        }
    }

    /* app/templates/winter/panels/SelectorPanel.svelte generated by Svelte v3.16.5 */

    function add_css$3() {
        var style = element("style");
        style.id = "svelte-cjzzpf-style";
        style.textContent = ".icon-info.svelte-cjzzpf{cursor:pointer}.content.svelte-cjzzpf{padding:1rem 1.5rem}";
        append(document.head, style);
    }

    function get_each_context$4(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[9] = list[i];
        return child_ctx;
    }

    // (45:0) {#if isAuth(environment, 'oauth2')}
    function create_if_block_1$6(ctx) {
        let show_if;
        let current_block_type_index;
        let if_block;
        let if_block_anchor;
        let current;
        const if_block_creators = [create_if_block_2$3, create_if_block_3$1, create_else_block_1];
        const if_blocks = [];

        function select_block_type(ctx, dirty) {
            if (/*authenticating*/ ctx[1]) return 0;
            if (dirty & /*$auth, $env*/ 96) show_if = !!/*$auth*/ ctx[6].includes(/*$env*/ ctx[5]);
            if (show_if) return 1;
            return 2;
        }

        current_block_type_index = select_block_type(ctx, -1);
        if_block = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);

        return {
            c() {
                if_block.c();
                if_block_anchor = empty();
            },
            m(target, anchor) {
                if_blocks[current_block_type_index].m(target, anchor);
                insert(target, if_block_anchor, anchor);
                current = true;
            },
            p(ctx, dirty) {
                let previous_block_index = current_block_type_index;
                current_block_type_index = select_block_type(ctx, dirty);

                if (current_block_type_index === previous_block_index) {
                    if_blocks[current_block_type_index].p(ctx, dirty);
                } else {
                    group_outros();

                    transition_out(if_blocks[previous_block_index], 1, 1, () => {
                        if_blocks[previous_block_index] = null;
                    });

                    check_outros();
                    if_block = if_blocks[current_block_type_index];

                    if (!if_block) {
                        if_block = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);
                        if_block.c();
                    }

                    transition_in(if_block, 1);
                    if_block.m(if_block_anchor.parentNode, if_block_anchor);
                }
            },
            i(local) {
                if (current) return;
                transition_in(if_block);
                current = true;
            },
            o(local) {
                transition_out(if_block);
                current = false;
            },
            d(detaching) {
                if_blocks[current_block_type_index].d(detaching);
                if (detaching) detach(if_block_anchor);
            }
        };
    }

    // (60:2) {:else}
    function create_else_block_1(ctx) {
        let div1;
        let div0;
        let p;
        let current;

        const loginbutton = new LoginButton({
            props: {
                authOptions: /*environment*/ ctx[4].auth.options,
                isPKCE: isAuth(/*environment*/ ctx[4], "oauth2-pkce"),
                pkceChallenge: /*pkceChallenge*/ ctx[2]
            }
        });

        return {
            c() {
                div1 = element("div");
                div0 = element("div");
                p = element("p");
                create_component(loginbutton.$$.fragment);
                attr(p, "class", "control");
                attr(div0, "class", "field is-grouped");
                attr(div1, "class", "navbar-item");
            },
            m(target, anchor) {
                insert(target, div1, anchor);
                append(div1, div0);
                append(div0, p);
                mount_component(loginbutton, p, null);
                current = true;
            },
            p(ctx, dirty) {
                const loginbutton_changes = {};
                if (dirty & /*environment*/ 16) loginbutton_changes.authOptions = /*environment*/ ctx[4].auth.options;
                if (dirty & /*environment*/ 16) loginbutton_changes.isPKCE = isAuth(/*environment*/ ctx[4], "oauth2-pkce");
                if (dirty & /*pkceChallenge*/ 4) loginbutton_changes.pkceChallenge = /*pkceChallenge*/ ctx[2];
                loginbutton.$set(loginbutton_changes);
            },
            i(local) {
                if (current) return;
                transition_in(loginbutton.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(loginbutton.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                if (detaching) detach(div1);
                destroy_component(loginbutton);
            }
        };
    }

    // (52:33)
    function create_if_block_3$1(ctx) {
        let div1;
        let div0;
        let p;
        let current;
        const logoutbutton = new LogoutButton({});

        return {
            c() {
                div1 = element("div");
                div0 = element("div");
                p = element("p");
                create_component(logoutbutton.$$.fragment);
                attr(p, "class", "control");
                attr(div0, "class", "field is-grouped");
                attr(div1, "class", "navbar-item");
            },
            m(target, anchor) {
                insert(target, div1, anchor);
                append(div1, div0);
                append(div0, p);
                mount_component(logoutbutton, p, null);
                current = true;
            },
            p: noop,
            i(local) {
                if (current) return;
                transition_in(logoutbutton.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(logoutbutton.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                if (detaching) detach(div1);
                destroy_component(logoutbutton);
            }
        };
    }

    // (46:2) {#if authenticating}
    function create_if_block_2$3(ctx) {
        let div;

        return {
            c() {
                div = element("div");
                div.innerHTML = `<span class="icon is-medium has-text-danger"><i class="fas fa-2x fa-spinner fa-pulse"></i></span>`;
                attr(div, "class", "navbar-item");
            },
            m(target, anchor) {
                insert(target, div, anchor);
            },
            p: noop,
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(div);
            }
        };
    }

    // (80:4) {#each Object.keys(environments) as envName}
    function create_each_block$4(ctx) {
        let a;
        let t0_value = /*envName*/ ctx[9] + "";
        let t0;
        let t1;
        let a_data_name_value;
        let dispose;

        return {
            c() {
                a = element("a");
                t0 = text(t0_value);
                t1 = space();
                attr(a, "data-name", a_data_name_value = /*envName*/ ctx[9]);
                attr(a, "href", "javascript:void(0)");
                attr(a, "class", "navbar-item");
                dispose = listen(a, "click", /*handleClick*/ ctx[7]);
            },
            m(target, anchor) {
                insert(target, a, anchor);
                append(a, t0);
                append(a, t1);
            },
            p(ctx, dirty) {
                if (dirty & /*environments*/ 1 && t0_value !== (t0_value = /*envName*/ ctx[9] + "")) set_data(t0, t0_value);

                if (dirty & /*environments*/ 1 && a_data_name_value !== (a_data_name_value = /*envName*/ ctx[9])) {
                    attr(a, "data-name", a_data_name_value);
                }
            },
            d(detaching) {
                if (detaching) detach(a);
                dispose();
            }
        };
    }

    // (106:8) {:else}
    function create_else_block$2(ctx) {
        let span;

        return {
            c() {
                span = element("span");
                span.textContent = "None";
                attr(span, "class", "is-capitalized");
            },
            m(target, anchor) {
                insert(target, span, anchor);
            },
            p: noop,
            d(detaching) {
                if (detaching) detach(span);
            }
        };
    }

    // (104:8) {#if environment.auth}
    function create_if_block$9(ctx) {
        let span;
        let t_value = /*environment*/ ctx[4].auth.name + "";
        let t;

        return {
            c() {
                span = element("span");
                t = text(t_value);
                attr(span, "class", "is-capitalized");
            },
            m(target, anchor) {
                insert(target, span, anchor);
                append(span, t);
            },
            p(ctx, dirty) {
                if (dirty & /*environment*/ 16 && t_value !== (t_value = /*environment*/ ctx[4].auth.name + "")) set_data(t, t_value);
            },
            d(detaching) {
                if (detaching) detach(span);
            }
        };
    }

    function create_fragment$b(ctx) {
        let show_if = isAuth(/*environment*/ ctx[4], "oauth2");
        let t0;
        let div1;
        let a0;
        let t1;
        let t2;
        let div0;
        let t3;
        let div4;
        let a1;
        let t4;
        let div3;
        let div2;
        let p0;
        let t5;
        let t6_value = /*environment*/ ctx[4].url + "";
        let t6;
        let t7;
        let p1;
        let t8;
        let current;
        let dispose;
        let if_block0 = show_if && create_if_block_1$6(ctx);
        let each_value = Object.keys(/*environments*/ ctx[0]);
        let each_blocks = [];

        for (let i = 0; i < each_value.length; i += 1) {
            each_blocks[i] = create_each_block$4(get_each_context$4(ctx, each_value, i));
        }

        function select_block_type_1(ctx, dirty) {
            if (/*environment*/ ctx[4].auth) return create_if_block$9;
            return create_else_block$2;
        }

        let current_block_type = select_block_type_1(ctx, -1);
        let if_block1 = current_block_type(ctx);

        return {
            c() {
                if (if_block0) if_block0.c();
                t0 = space();
                div1 = element("div");
                a0 = element("a");
                t1 = text(/*$env*/ ctx[5]);
                t2 = space();
                div0 = element("div");

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].c();
                }

                t3 = space();
                div4 = element("div");
                a1 = element("a");
                a1.innerHTML = `<span class="icon icon-info is-medium has-text-grey-light svelte-cjzzpf"><i class="fas fa-lg fa-info-circle"></i></span>`;
                t4 = space();
                div3 = element("div");
                div2 = element("div");
                p0 = element("p");
                t5 = text("BaseURL: ");
                t6 = text(t6_value);
                t7 = space();
                p1 = element("p");
                t8 = text("Auth:\n        ");
                if_block1.c();
                attr(a0, "href", "javascript:void(0)");
                attr(a0, "class", "navbar-link");
                attr(div0, "class", "navbar-dropdown is-right");
                attr(div1, "class", "navbar-item has-dropdown is-capitalized");
                toggle_class(div1, "is-active", /*show*/ ctx[3]);
                attr(a1, "href", "javascript:void(0)");
                attr(a1, "class", "navbar-link is-arrowless");
                attr(div2, "class", "content svelte-cjzzpf");
                attr(div3, "class", "navbar-dropdown is-right");
                attr(div4, "class", "navbar-item has-dropdown is-hoverable");
                dispose = listen(a0, "click", /*toggleClick*/ ctx[8]);
            },
            m(target, anchor) {
                if (if_block0) if_block0.m(target, anchor);
                insert(target, t0, anchor);
                insert(target, div1, anchor);
                append(div1, a0);
                append(a0, t1);
                append(div1, t2);
                append(div1, div0);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].m(div0, null);
                }

                insert(target, t3, anchor);
                insert(target, div4, anchor);
                append(div4, a1);
                append(div4, t4);
                append(div4, div3);
                append(div3, div2);
                append(div2, p0);
                append(p0, t5);
                append(p0, t6);
                append(div2, t7);
                append(div2, p1);
                append(p1, t8);
                if_block1.m(p1, null);
                current = true;
            },
            p(ctx, [dirty]) {
                if (dirty & /*environment*/ 16) show_if = isAuth(/*environment*/ ctx[4], "oauth2");

                if (show_if) {
                    if (if_block0) {
                        if_block0.p(ctx, dirty);
                        transition_in(if_block0, 1);
                    } else {
                        if_block0 = create_if_block_1$6(ctx);
                        if_block0.c();
                        transition_in(if_block0, 1);
                        if_block0.m(t0.parentNode, t0);
                    }
                } else if (if_block0) {
                    group_outros();

                    transition_out(if_block0, 1, 1, () => {
                        if_block0 = null;
                    });

                    check_outros();
                }

                if (!current || dirty & /*$env*/ 32) set_data(t1, /*$env*/ ctx[5]);

                if (dirty & /*Object, environments, handleClick*/ 129) {
                    each_value = Object.keys(/*environments*/ ctx[0]);
                    let i;

                    for (i = 0; i < each_value.length; i += 1) {
                        const child_ctx = get_each_context$4(ctx, each_value, i);

                        if (each_blocks[i]) {
                            each_blocks[i].p(child_ctx, dirty);
                        } else {
                            each_blocks[i] = create_each_block$4(child_ctx);
                            each_blocks[i].c();
                            each_blocks[i].m(div0, null);
                        }
                    }

                    for (; i < each_blocks.length; i += 1) {
                        each_blocks[i].d(1);
                    }

                    each_blocks.length = each_value.length;
                }

                if (dirty & /*show*/ 8) {
                    toggle_class(div1, "is-active", /*show*/ ctx[3]);
                }

                if ((!current || dirty & /*environment*/ 16) && t6_value !== (t6_value = /*environment*/ ctx[4].url + "")) set_data(t6, t6_value);

                if (current_block_type === (current_block_type = select_block_type_1(ctx, dirty)) && if_block1) {
                    if_block1.p(ctx, dirty);
                } else {
                    if_block1.d(1);
                    if_block1 = current_block_type(ctx);

                    if (if_block1) {
                        if_block1.c();
                        if_block1.m(p1, null);
                    }
                }
            },
            i(local) {
                if (current) return;
                transition_in(if_block0);
                current = true;
            },
            o(local) {
                transition_out(if_block0);
                current = false;
            },
            d(detaching) {
                if (if_block0) if_block0.d(detaching);
                if (detaching) detach(t0);
                if (detaching) detach(div1);
                destroy_each(each_blocks, detaching);
                if (detaching) detach(t3);
                if (detaching) detach(div4);
                if_block1.d();
                dispose();
            }
        };
    }

    function instance$b($$self, $$props, $$invalidate) {
        let $env;
        let $auth;
        component_subscribe($$self, env, $$value => $$invalidate(5, $env = $$value));
        component_subscribe($$self, auth, $$value => $$invalidate(6, $auth = $$value));
        let { environments } = $$props;
        let { authenticating } = $$props;
        let { pkceChallenge } = $$props;
        let show = false;

        function handleClick(event) {
            $$invalidate(3, show = false);
            const envName = event.target.dataset["name"];
            env.set(envName);
            const authToken = getToken($env);

            if (authToken) {
                auth.add(envName);
                token.set(authToken);
            }
        }

        function toggleClick() {
            $$invalidate(3, show = !show);
        }

        $$self.$set = $$props => {
            if ("environments" in $$props) $$invalidate(0, environments = $$props.environments);
            if ("authenticating" in $$props) $$invalidate(1, authenticating = $$props.authenticating);
            if ("pkceChallenge" in $$props) $$invalidate(2, pkceChallenge = $$props.pkceChallenge);
        };

        let environment;

        $$self.$$.update = () => {
            if ($$self.$$.dirty & /*environments, $env*/ 33) {
                $$invalidate(4, environment = environments[$env]);
            }
        };

        return [
            environments,
            authenticating,
            pkceChallenge,
            show,
            environment,
            $env,
            $auth,
            handleClick,
            toggleClick
        ];
    }

    class SelectorPanel extends SvelteComponent {
        constructor(options) {
            super();
            if (!document.getElementById("svelte-cjzzpf-style")) add_css$3();

            init(this, options, instance$b, create_fragment$b, safe_not_equal, {
                environments: 0,
                authenticating: 1,
                pkceChallenge: 2
            });
        }
    }

    /* app/templates/winter/components/ToggleIcon.svelte generated by Svelte v3.16.5 */

    function add_css$4() {
        var style = element("style");
        style.id = "svelte-o7a14x-style";
        style.textContent = ".toggle-icon.svelte-o7a14x{cursor:pointer}";
        append(document.head, style);
    }

    function create_fragment$c(ctx) {
        let span;
        let i;
        let span_class_value;
        let dispose;

        return {
            c() {
                span = element("span");
                i = element("i");
                attr(i, "class", "fas");
                toggle_class(i, "fa-chevron-up", !/*show*/ ctx[0]);
                toggle_class(i, "fa-chevron-down", /*show*/ ctx[0]);
                attr(span, "class", span_class_value = "toggle-icon icon " + /*additionalClass*/ ctx[2] + " svelte-o7a14x");
                toggle_class(span, "has-text-grey", !/*dark*/ ctx[1]);
                dispose = listen(span, "click", /*toggle*/ ctx[3]);
            },
            m(target, anchor) {
                insert(target, span, anchor);
                append(span, i);
            },
            p(ctx, [dirty]) {
                if (dirty & /*show*/ 1) {
                    toggle_class(i, "fa-chevron-up", !/*show*/ ctx[0]);
                }

                if (dirty & /*show*/ 1) {
                    toggle_class(i, "fa-chevron-down", /*show*/ ctx[0]);
                }

                if (dirty & /*additionalClass*/ 4 && span_class_value !== (span_class_value = "toggle-icon icon " + /*additionalClass*/ ctx[2] + " svelte-o7a14x")) {
                    attr(span, "class", span_class_value);
                }

                if (dirty & /*additionalClass, dark*/ 6) {
                    toggle_class(span, "has-text-grey", !/*dark*/ ctx[1]);
                }
            },
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(span);
                dispose();
            }
        };
    }

    function instance$c($$self, $$props, $$invalidate) {
        let { dark = false } = $$props;
        let { show = false } = $$props;
        let { additionalClass = "" } = $$props;
        let { handleClick } = $$props;

        function toggle(event) {
            $$invalidate(0, show = !show);
            handleClick(event);
        }

        $$self.$set = $$props => {
            if ("dark" in $$props) $$invalidate(1, dark = $$props.dark);
            if ("show" in $$props) $$invalidate(0, show = $$props.show);
            if ("additionalClass" in $$props) $$invalidate(2, additionalClass = $$props.additionalClass);
            if ("handleClick" in $$props) $$invalidate(4, handleClick = $$props.handleClick);
        };

        return [show, dark, additionalClass, toggle, handleClick];
    }

    class ToggleIcon extends SvelteComponent {
        constructor(options) {
            super();
            if (!document.getElementById("svelte-o7a14x-style")) add_css$4();

            init(this, options, instance$c, create_fragment$c, safe_not_equal, {
                dark: 1,
                show: 0,
                additionalClass: 2,
                handleClick: 4
            });
        }
    }

    /* app/templates/winter/panels/CollapsiblePanel.svelte generated by Svelte v3.16.5 */

    function add_css$5() {
        var style = element("style");
        style.id = "svelte-1hkyt70-style";
        style.textContent = ".panel-section.svelte-1hkyt70{padding:1em;border:1px solid #dbdbdb;border-top:none}.panel-button.svelte-1hkyt70{border-radius:4px}.panel-dark.svelte-1hkyt70{border:1px solid #363636}.panel-section.is-darkmode.svelte-1hkyt70{background-color:#222 !important;border-color:#333}";
        append(document.head, style);
    }

    const get_body_slot_changes = dirty => ({});
    const get_body_slot_context = ctx => ({});
    const get_heading_slot_changes = dirty => ({});
    const get_heading_slot_context = ctx => ({});

    function create_fragment$d(ctx) {
        let div2;
        let div0;
        let t0;
        let t1;
        let div1;
        let current;
        const heading_slot_template = /*$$slots*/ ctx[4].heading;
        const heading_slot = create_slot(heading_slot_template, ctx, /*$$scope*/ ctx[3], get_heading_slot_context);

        const toggleicon = new ToggleIcon({
            props: {
                dark: /*dark*/ ctx[1],
                show: /*show*/ ctx[0],
                additionalClass: "is-pulled-right",
                handleClick: /*func*/ ctx[5]
            }
        });

        const body_slot_template = /*$$slots*/ ctx[4].body;
        const body_slot = create_slot(body_slot_template, ctx, /*$$scope*/ ctx[3], get_body_slot_context);

        return {
            c() {
                div2 = element("div");
                div0 = element("div");
                if (heading_slot) heading_slot.c();
                t0 = space();
                create_component(toggleicon.$$.fragment);
                t1 = space();
                div1 = element("div");
                if (body_slot) body_slot.c();
                attr(div0, "class", "panel-heading svelte-1hkyt70");
                toggle_class(div0, "has-background-dark", /*dark*/ ctx[1]);
                toggle_class(div0, "has-text-white", /*dark*/ ctx[1]);
                toggle_class(div0, "panel-dark", /*dark*/ ctx[1]);
                toggle_class(div0, "panel-button", !/*show*/ ctx[0]);
                attr(div1, "class", "panel-section has-background-white svelte-1hkyt70");
                toggle_class(div1, "is-hidden", !/*show*/ ctx[0]);
                toggle_class(div1, "is-darkmode", /*isDarkmode*/ ctx[2]);
                attr(div2, "class", "panel");
            },
            m(target, anchor) {
                insert(target, div2, anchor);
                append(div2, div0);

                if (heading_slot) {
                    heading_slot.m(div0, null);
                }

                append(div0, t0);
                mount_component(toggleicon, div0, null);
                append(div2, t1);
                append(div2, div1);

                if (body_slot) {
                    body_slot.m(div1, null);
                }

                current = true;
            },
            p(ctx, [dirty]) {
                if (heading_slot && heading_slot.p && dirty & /*$$scope*/ 8) {
                    heading_slot.p(get_slot_context(heading_slot_template, ctx, /*$$scope*/ ctx[3], get_heading_slot_context), get_slot_changes(heading_slot_template, /*$$scope*/ ctx[3], dirty, get_heading_slot_changes));
                }

                const toggleicon_changes = {};
                if (dirty & /*dark*/ 2) toggleicon_changes.dark = /*dark*/ ctx[1];
                if (dirty & /*show*/ 1) toggleicon_changes.show = /*show*/ ctx[0];
                if (dirty & /*show*/ 1) toggleicon_changes.handleClick = /*func*/ ctx[5];
                toggleicon.$set(toggleicon_changes);

                if (dirty & /*dark*/ 2) {
                    toggle_class(div0, "has-background-dark", /*dark*/ ctx[1]);
                }

                if (dirty & /*dark*/ 2) {
                    toggle_class(div0, "has-text-white", /*dark*/ ctx[1]);
                }

                if (dirty & /*dark*/ 2) {
                    toggle_class(div0, "panel-dark", /*dark*/ ctx[1]);
                }

                if (dirty & /*show*/ 1) {
                    toggle_class(div0, "panel-button", !/*show*/ ctx[0]);
                }

                if (body_slot && body_slot.p && dirty & /*$$scope*/ 8) {
                    body_slot.p(get_slot_context(body_slot_template, ctx, /*$$scope*/ ctx[3], get_body_slot_context), get_slot_changes(body_slot_template, /*$$scope*/ ctx[3], dirty, get_body_slot_changes));
                }

                if (dirty & /*show*/ 1) {
                    toggle_class(div1, "is-hidden", !/*show*/ ctx[0]);
                }

                if (dirty & /*isDarkmode*/ 4) {
                    toggle_class(div1, "is-darkmode", /*isDarkmode*/ ctx[2]);
                }
            },
            i(local) {
                if (current) return;
                transition_in(heading_slot, local);
                transition_in(toggleicon.$$.fragment, local);
                transition_in(body_slot, local);
                current = true;
            },
            o(local) {
                transition_out(heading_slot, local);
                transition_out(toggleicon.$$.fragment, local);
                transition_out(body_slot, local);
                current = false;
            },
            d(detaching) {
                if (detaching) detach(div2);
                if (heading_slot) heading_slot.d(detaching);
                destroy_component(toggleicon);
                if (body_slot) body_slot.d(detaching);
            }
        };
    }

    function instance$d($$self, $$props, $$invalidate) {
        let { dark = false } = $$props;
        let { show = false } = $$props;
        let { isDarkmode } = $$props;
        let { $$slots = {}, $$scope } = $$props;
        const func = () => $$invalidate(0, show = !show);

        $$self.$set = $$props => {
            if ("dark" in $$props) $$invalidate(1, dark = $$props.dark);
            if ("show" in $$props) $$invalidate(0, show = $$props.show);
            if ("isDarkmode" in $$props) $$invalidate(2, isDarkmode = $$props.isDarkmode);
            if ("$$scope" in $$props) $$invalidate(3, $$scope = $$props.$$scope);
        };

        return [show, dark, isDarkmode, $$scope, $$slots, func];
    }

    class CollapsiblePanel extends SvelteComponent {
        constructor(options) {
            super();
            if (!document.getElementById("svelte-1hkyt70-style")) add_css$5();
            init(this, options, instance$d, create_fragment$d, safe_not_equal, { dark: 1, show: 0, isDarkmode: 2 });
        }
    }

    /* app/templates/winter/components/FieldDisabled.svelte generated by Svelte v3.16.5 */

    function add_css$6() {
        var style = element("style");
        style.id = "svelte-a7ak6u-style";
        style.textContent = ".control-switch.svelte-a7ak6u{padding-top:0.4rem}.has-border.svelte-a7ak6u{border-color:#dbdbdb}";
        append(document.head, style);
    }

    function create_fragment$e(ctx) {
        let div;
        let p0;
        let input0;
        let input0_id_value;
        let t0;
        let label;
        let label_for_value;
        let t1;
        let p1;
        let input1;
        let t2;
        let p2;
        let input2;

        return {
            c() {
                div = element("div");
                p0 = element("p");
                input0 = element("input");
                t0 = space();
                label = element("label");
                t1 = space();
                p1 = element("p");
                input1 = element("input");
                t2 = space();
                p2 = element("p");
                input2 = element("input");
                attr(input0, "class", "switch is-rounded is-success");
                attr(input0, "id", input0_id_value = "h-" + /*name*/ ctx[0]);
                attr(input0, "type", "checkbox");
                input0.checked = true;
                input0.disabled = true;
                attr(label, "for", label_for_value = "h-" + /*name*/ ctx[0]);
                attr(p0, "class", "control control-switch svelte-a7ak6u");
                attr(input1, "class", "input is-rounded has-border svelte-a7ak6u");
                attr(input1, "type", "text");
                attr(input1, "placeholder", /*placeholder*/ ctx[1]);
                input1.disabled = true;
                attr(p1, "class", "control");
                attr(input2, "class", "input is-rounded has-border is-family-code svelte-a7ak6u");
                attr(input2, "type", "text");
                input2.value = /*value*/ ctx[2];
                input2.disabled = true;
                attr(p2, "class", "control is-expanded");
                attr(div, "class", "field has-addons");
            },
            m(target, anchor) {
                insert(target, div, anchor);
                append(div, p0);
                append(p0, input0);
                append(p0, t0);
                append(p0, label);
                append(div, t1);
                append(div, p1);
                append(p1, input1);
                append(div, t2);
                append(div, p2);
                append(p2, input2);
            },
            p(ctx, [dirty]) {
                if (dirty & /*name*/ 1 && input0_id_value !== (input0_id_value = "h-" + /*name*/ ctx[0])) {
                    attr(input0, "id", input0_id_value);
                }

                if (dirty & /*name*/ 1 && label_for_value !== (label_for_value = "h-" + /*name*/ ctx[0])) {
                    attr(label, "for", label_for_value);
                }

                if (dirty & /*placeholder*/ 2) {
                    attr(input1, "placeholder", /*placeholder*/ ctx[1]);
                }

                if (dirty & /*value*/ 4) {
                    input2.value = /*value*/ ctx[2];
                }
            },
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(div);
            }
        };
    }

    function instance$e($$self, $$props, $$invalidate) {
        let { name } = $$props;
        let { placeholder } = $$props;
        let { value } = $$props;

        $$self.$set = $$props => {
            if ("name" in $$props) $$invalidate(0, name = $$props.name);
            if ("placeholder" in $$props) $$invalidate(1, placeholder = $$props.placeholder);
            if ("value" in $$props) $$invalidate(2, value = $$props.value);
        };

        return [name, placeholder, value];
    }

    class FieldDisabled extends SvelteComponent {
        constructor(options) {
            super();
            if (!document.getElementById("svelte-a7ak6u-style")) add_css$6();
            init(this, options, instance$e, create_fragment$e, safe_not_equal, { name: 0, placeholder: 1, value: 2 });
        }
    }

    /* app/templates/winter/components/FieldSwitch.svelte generated by Svelte v3.16.5 */

    function add_css$7() {
        var style = element("style");
        style.id = "svelte-a7ak6u-style";
        style.textContent = ".control-switch.svelte-a7ak6u{padding-top:0.4rem}.has-border.svelte-a7ak6u{border-color:#dbdbdb}";
        append(document.head, style);
    }

    function create_fragment$f(ctx) {
        let div;
        let p0;
        let input0;
        let input0_id_value;
        let t0;
        let label;
        let label_for_value;
        let t1;
        let p1;
        let input1;
        let t2;
        let p2;
        let input2;
        let dispose;

        return {
            c() {
                div = element("div");
                p0 = element("p");
                input0 = element("input");
                t0 = space();
                label = element("label");
                t1 = space();
                p1 = element("p");
                input1 = element("input");
                t2 = space();
                p2 = element("p");
                input2 = element("input");
                attr(input0, "class", "switch is-rounded is-success");
                attr(input0, "id", input0_id_value = "p-" + /*name*/ ctx[3]);
                attr(input0, "type", "checkbox");
                input0.disabled = /*required*/ ctx[2];
                attr(label, "for", label_for_value = "p-" + /*name*/ ctx[3]);
                attr(p0, "class", "control control-switch svelte-a7ak6u");
                attr(input1, "class", "input is-rounded has-border svelte-a7ak6u");
                attr(input1, "type", "text");
                attr(input1, "placeholder", /*name*/ ctx[3]);
                input1.disabled = true;
                attr(p1, "class", "control");
                attr(input2, "class", "input has-border is-family-code svelte-a7ak6u");
                attr(input2, "type", "text");
                toggle_class(input2, "is-rounded", /*rounded*/ ctx[4]);
                attr(p2, "class", "control is-expanded");
                attr(div, "class", "field has-addons");

                dispose = [
                    listen(input0, "change", /*input0_change_handler*/ ctx[5]),
                    listen(input2, "input", /*input2_input_handler*/ ctx[6])
                ];
            },
            m(target, anchor) {
                insert(target, div, anchor);
                append(div, p0);
                append(p0, input0);
                input0.checked = /*used*/ ctx[0];
                append(p0, t0);
                append(p0, label);
                append(div, t1);
                append(div, p1);
                append(p1, input1);
                append(div, t2);
                append(div, p2);
                append(p2, input2);
                set_input_value(input2, /*value*/ ctx[1]);
            },
            p(ctx, [dirty]) {
                if (dirty & /*name*/ 8 && input0_id_value !== (input0_id_value = "p-" + /*name*/ ctx[3])) {
                    attr(input0, "id", input0_id_value);
                }

                if (dirty & /*required*/ 4) {
                    input0.disabled = /*required*/ ctx[2];
                }

                if (dirty & /*used*/ 1) {
                    input0.checked = /*used*/ ctx[0];
                }

                if (dirty & /*name*/ 8 && label_for_value !== (label_for_value = "p-" + /*name*/ ctx[3])) {
                    attr(label, "for", label_for_value);
                }

                if (dirty & /*name*/ 8) {
                    attr(input1, "placeholder", /*name*/ ctx[3]);
                }

                if (dirty & /*value*/ 2 && input2.value !== /*value*/ ctx[1]) {
                    set_input_value(input2, /*value*/ ctx[1]);
                }

                if (dirty & /*rounded*/ 16) {
                    toggle_class(input2, "is-rounded", /*rounded*/ ctx[4]);
                }
            },
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(div);
                run_all(dispose);
            }
        };
    }

    function instance$f($$self, $$props, $$invalidate) {
        let { used } = $$props;
        let { required } = $$props;
        let { name } = $$props;
        let { value } = $$props;
        let { rounded } = $$props;

        function input0_change_handler() {
            used = this.checked;
            $$invalidate(0, used);
        }

        function input2_input_handler() {
            value = this.value;
            $$invalidate(1, value);
        }

        $$self.$set = $$props => {
            if ("used" in $$props) $$invalidate(0, used = $$props.used);
            if ("required" in $$props) $$invalidate(2, required = $$props.required);
            if ("name" in $$props) $$invalidate(3, name = $$props.name);
            if ("value" in $$props) $$invalidate(1, value = $$props.value);
            if ("rounded" in $$props) $$invalidate(4, rounded = $$props.rounded);
        };

        return [
            used,
            value,
            required,
            name,
            rounded,
            input0_change_handler,
            input2_input_handler
        ];
    }

    class FieldSwitch extends SvelteComponent {
        constructor(options) {
            super();
            if (!document.getElementById("svelte-a7ak6u-style")) add_css$7();

            init(this, options, instance$f, create_fragment$f, safe_not_equal, {
                used: 0,
                required: 2,
                name: 3,
                value: 1,
                rounded: 4
            });
        }
    }

    /* app/templates/winter/panels/PlaygroundPanel.svelte generated by Svelte v3.16.5 */

    function add_css$8() {
        var style = element("style");
        style.id = "svelte-c3oocm-style";
        style.textContent = ".small-section.svelte-c3oocm{padding-top:0.5rem}.button-left.svelte-c3oocm{justify-content:left}.control-switch.svelte-c3oocm{padding-top:0.4rem}.container-content.svelte-c3oocm{padding:0.5rem 1rem;border-radius:4px;margin-top:0.5rem;background-color:#2b2b2b}.content-header.svelte-c3oocm{color:#fff;border-bottom:dashed 1px #777;padding-top:0.5rem;padding-bottom:1rem}.hero-small.svelte-c3oocm{padding:1.5rem}.has-border.svelte-c3oocm{border-color:#dbdbdb}.hero-rounded.svelte-c3oocm{border-radius:4px}";
        append(document.head, style);
    }

    function get_each_context$5(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[29] = list[i][0];
        child_ctx[30] = list[i][1];
        return child_ctx;
    }

    function get_each_context_1$1(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[33] = list[i];
        child_ctx[34] = list;
        child_ctx[35] = i;
        return child_ctx;
    }

    function get_each_context_2$1(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[36] = list[i];
        child_ctx[37] = list;
        child_ctx[38] = i;
        return child_ctx;
    }

    // (119:2) <span slot="heading">
    function create_heading_slot(ctx) {
        let span;

        return {
            c() {
                span = element("span");
                span.textContent = "Playground";
                attr(span, "slot", "heading");
            },
            m(target, anchor) {
                insert(target, span, anchor);
            },
            d(detaching) {
                if (detaching) detach(span);
            }
        };
    }

    // (128:8) {:else}
    function create_else_block_4(ctx) {
        let a;
        let span0;
        let t0_value = /*currentAction*/ ctx[5].method + "";
        let t0;
        let t1;
        let span1;
        let t2_value = /*currentUrl*/ ctx[12].origin + "";
        let t2;
        let t3;
        let span2;
        let t4_value = /*currentUrl*/ ctx[12].pathname + "";
        let t4;
        let dispose;

        return {
            c() {
                a = element("a");
                span0 = element("span");
                t0 = text(t0_value);
                t1 = text("\n             \n            ");
                span1 = element("span");
                t2 = text(t2_value);
                t3 = space();
                span2 = element("span");
                t4 = text(t4_value);
                attr(span0, "class", "is-uppercase has-text-weight-bold");
                attr(span2, "class", "has-text-weight-bold");
                attr(a, "href", "javascript:void(0)");
                attr(a, "class", "button button-left is-warning is-family-code is-fullwidth svelte-c3oocm");
                dispose = listen(a, "click", /*handleCopy*/ ctx[17]);
            },
            m(target, anchor) {
                insert(target, a, anchor);
                append(a, span0);
                append(span0, t0);
                append(a, t1);
                append(a, span1);
                append(span1, t2);
                append(a, t3);
                append(a, span2);
                append(span2, t4);
            },
            p(ctx, dirty) {
                if (dirty[0] & /*currentAction*/ 32 && t0_value !== (t0_value = /*currentAction*/ ctx[5].method + "")) set_data(t0, t0_value);
                if (dirty[0] & /*currentUrl*/ 4096 && t2_value !== (t2_value = /*currentUrl*/ ctx[12].origin + "")) set_data(t2, t2_value);
                if (dirty[0] & /*currentUrl*/ 4096 && t4_value !== (t4_value = /*currentUrl*/ ctx[12].pathname + "")) set_data(t4, t4_value);
            },
            d(detaching) {
                if (detaching) detach(a);
                dispose();
            }
        };
    }

    // (123:8) {#if copying}
    function create_if_block_10(ctx) {
        let button;

        return {
            c() {
                button = element("button");
                button.innerHTML = `<span>URL has been copied to clipboard.</span>`;
                attr(button, "class", "button button-left is-warning is-family-code is-fullwidth svelte-c3oocm");
            },
            m(target, anchor) {
                insert(target, button, anchor);
            },
            p: noop,
            d(detaching) {
                if (detaching) detach(button);
            }
        };
    }

    // (149:8) {:else}
    function create_else_block_3(ctx) {
        let button;
        let dispose;

        return {
            c() {
                button = element("button");

                button.innerHTML = `<span class="icon"><i class="fas fa-paper-plane"></i></span>
            <span>Send</span>`;

                attr(button, "class", "button is-success is-fullwidth");
                dispose = listen(button, "click", /*handleClick*/ ctx[15]);
            },
            m(target, anchor) {
                insert(target, button, anchor);
            },
            p: noop,
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(button);
                dispose();
            }
        };
    }

    // (143:8) {#if (isAuth(environment, 'oauth2') || isAuth(environment, 'oauth2-pkce')) && !$auth.includes($env)}
    function create_if_block_9(ctx) {
        let current;

        const loginbutton = new LoginButton({
            props: {
                authOptions: /*environment*/ ctx[10].auth.options,
                isPKCE: isAuth(/*environment*/ ctx[10], "oauth2-pkce"),
                pkceChallenge: /*pkceChallenge*/ ctx[6],
                fullWidth: true
            }
        });

        return {
            c() {
                create_component(loginbutton.$$.fragment);
            },
            m(target, anchor) {
                mount_component(loginbutton, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const loginbutton_changes = {};
                if (dirty[0] & /*environment*/ 1024) loginbutton_changes.authOptions = /*environment*/ ctx[10].auth.options;
                if (dirty[0] & /*environment*/ 1024) loginbutton_changes.isPKCE = isAuth(/*environment*/ ctx[10], "oauth2-pkce");
                if (dirty[0] & /*pkceChallenge*/ 64) loginbutton_changes.pkceChallenge = /*pkceChallenge*/ ctx[6];
                loginbutton.$set(loginbutton_changes);
            },
            i(local) {
                if (current) return;
                transition_in(loginbutton.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(loginbutton.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(loginbutton, detaching);
            }
        };
    }

    // (181:6) {:else}
    function create_else_block_2(ctx) {
        let each_1_anchor;
        let current;
        let each_value_2 = /*requestHeaders*/ ctx[0];
        let each_blocks = [];

        for (let i = 0; i < each_value_2.length; i += 1) {
            each_blocks[i] = create_each_block_2$1(get_each_context_2$1(ctx, each_value_2, i));
        }

        const out = i => transition_out(each_blocks[i], 1, 1, () => {
            each_blocks[i] = null;
        });

        return {
            c() {
                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].c();
                }

                each_1_anchor = empty();
            },
            m(target, anchor) {
                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].m(target, anchor);
                }

                insert(target, each_1_anchor, anchor);
                current = true;
            },
            p(ctx, dirty) {
                if (dirty[0] & /*requestHeaders*/ 1) {
                    each_value_2 = /*requestHeaders*/ ctx[0];
                    let i;

                    for (i = 0; i < each_value_2.length; i += 1) {
                        const child_ctx = get_each_context_2$1(ctx, each_value_2, i);

                        if (each_blocks[i]) {
                            each_blocks[i].p(child_ctx, dirty);
                            transition_in(each_blocks[i], 1);
                        } else {
                            each_blocks[i] = create_each_block_2$1(child_ctx);
                            each_blocks[i].c();
                            transition_in(each_blocks[i], 1);
                            each_blocks[i].m(each_1_anchor.parentNode, each_1_anchor);
                        }
                    }

                    group_outros();

                    for (i = each_value_2.length; i < each_blocks.length; i += 1) {
                        out(i);
                    }

                    check_outros();
                }
            },
            i(local) {
                if (current) return;

                for (let i = 0; i < each_value_2.length; i += 1) {
                    transition_in(each_blocks[i]);
                }

                current = true;
            },
            o(local) {
                each_blocks = each_blocks.filter(Boolean);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    transition_out(each_blocks[i]);
                }

                current = false;
            },
            d(detaching) {
                destroy_each(each_blocks, detaching);
                if (detaching) detach(each_1_anchor);
            }
        };
    }

    // (177:6) {#if requestHeaders.length === 0 && !environment.auth}
    function create_if_block_8(ctx) {
        let p;

        return {
            c() {
                p = element("p");
                p.innerHTML = `<em>No configurable headers.</em>`;
            },
            m(target, anchor) {
                insert(target, p, anchor);
            },
            p: noop,
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(p);
            }
        };
    }

    // (182:8) {#each requestHeaders as header}
    function create_each_block_2$1(ctx) {
        let updating_used;
        let updating_value;
        let current;

        function fieldswitch_used_binding(value) {
            /*fieldswitch_used_binding*/ ctx[22].call(null, value, /*header*/ ctx[36]);
        }

        function fieldswitch_value_binding(value_1) {
            /*fieldswitch_value_binding*/ ctx[23].call(null, value_1, /*header*/ ctx[36]);
        }

        let fieldswitch_props = {
            name: /*header*/ ctx[36].name,
            required: /*header*/ ctx[36].required,
            rounded: true
        };

        if (/*header*/ ctx[36].used !== void 0) {
            fieldswitch_props.used = /*header*/ ctx[36].used;
        }

        if (/*header*/ ctx[36].value !== void 0) {
            fieldswitch_props.value = /*header*/ ctx[36].value;
        }

        const fieldswitch = new FieldSwitch({ props: fieldswitch_props });
        binding_callbacks.push(() => bind(fieldswitch, "used", fieldswitch_used_binding));
        binding_callbacks.push(() => bind(fieldswitch, "value", fieldswitch_value_binding));

        return {
            c() {
                create_component(fieldswitch.$$.fragment);
            },
            m(target, anchor) {
                mount_component(fieldswitch, target, anchor);
                current = true;
            },
            p(new_ctx, dirty) {
                ctx = new_ctx;
                const fieldswitch_changes = {};
                if (dirty[0] & /*requestHeaders*/ 1) fieldswitch_changes.name = /*header*/ ctx[36].name;
                if (dirty[0] & /*requestHeaders*/ 1) fieldswitch_changes.required = /*header*/ ctx[36].required;

                if (!updating_used && dirty[0] & /*requestHeaders*/ 1) {
                    updating_used = true;
                    fieldswitch_changes.used = /*header*/ ctx[36].used;
                    add_flush_callback(() => updating_used = false);
                }

                if (!updating_value && dirty[0] & /*requestHeaders*/ 1) {
                    updating_value = true;
                    fieldswitch_changes.value = /*header*/ ctx[36].value;
                    add_flush_callback(() => updating_value = false);
                }

                fieldswitch.$set(fieldswitch_changes);
            },
            i(local) {
                if (current) return;
                transition_in(fieldswitch.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(fieldswitch.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(fieldswitch, detaching);
            }
        };
    }

    // (192:6) {#if isAuth(environment, 'basic')}
    function create_if_block_7(ctx) {
        let current;

        const fielddisabled = new FieldDisabled({
            props: {
                name: "authorization",
                placeholder: "Authorization",
                value: "Basic " + basicAuth(/*environment*/ ctx[10].auth.options.username, /*environment*/ ctx[10].auth.options.password)
            }
        });

        return {
            c() {
                create_component(fielddisabled.$$.fragment);
            },
            m(target, anchor) {
                mount_component(fielddisabled, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const fielddisabled_changes = {};
                if (dirty[0] & /*environment*/ 1024) fielddisabled_changes.value = "Basic " + basicAuth(/*environment*/ ctx[10].auth.options.username, /*environment*/ ctx[10].auth.options.password);
                fielddisabled.$set(fielddisabled_changes);
            },
            i(local) {
                if (current) return;
                transition_in(fielddisabled.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(fielddisabled.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(fielddisabled, detaching);
            }
        };
    }

    // (199:6) {#if isAuth(environment, 'apikey')}
    function create_if_block_6(ctx) {
        let current;

        const fielddisabled = new FieldDisabled({
            props: {
                name: "authorization",
                placeholder: /*environment*/ ctx[10].auth.options.header,
                value: /*environment*/ ctx[10].auth.options.key
            }
        });

        return {
            c() {
                create_component(fielddisabled.$$.fragment);
            },
            m(target, anchor) {
                mount_component(fielddisabled, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const fielddisabled_changes = {};
                if (dirty[0] & /*environment*/ 1024) fielddisabled_changes.placeholder = /*environment*/ ctx[10].auth.options.header;
                if (dirty[0] & /*environment*/ 1024) fielddisabled_changes.value = /*environment*/ ctx[10].auth.options.key;
                fielddisabled.$set(fielddisabled_changes);
            },
            i(local) {
                if (current) return;
                transition_in(fielddisabled.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(fielddisabled.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(fielddisabled, detaching);
            }
        };
    }

    // (206:6) {#if isAuth(environment, 'oauth2') || isAuth(environment, 'oauth2-pkce')}
    function create_if_block_4(ctx) {
        let show_if = /*$auth*/ ctx[13].includes(/*$env*/ ctx[11]);
        let if_block_anchor;
        let current;
        let if_block = show_if && create_if_block_5(ctx);

        return {
            c() {
                if (if_block) if_block.c();
                if_block_anchor = empty();
            },
            m(target, anchor) {
                if (if_block) if_block.m(target, anchor);
                insert(target, if_block_anchor, anchor);
                current = true;
            },
            p(ctx, dirty) {
                if (dirty[0] & /*$auth, $env*/ 10240) show_if = /*$auth*/ ctx[13].includes(/*$env*/ ctx[11]);

                if (show_if) {
                    if (if_block) {
                        if_block.p(ctx, dirty);
                        transition_in(if_block, 1);
                    } else {
                        if_block = create_if_block_5(ctx);
                        if_block.c();
                        transition_in(if_block, 1);
                        if_block.m(if_block_anchor.parentNode, if_block_anchor);
                    }
                } else if (if_block) {
                    group_outros();

                    transition_out(if_block, 1, 1, () => {
                        if_block = null;
                    });

                    check_outros();
                }
            },
            i(local) {
                if (current) return;
                transition_in(if_block);
                current = true;
            },
            o(local) {
                transition_out(if_block);
                current = false;
            },
            d(detaching) {
                if (if_block) if_block.d(detaching);
                if (detaching) detach(if_block_anchor);
            }
        };
    }

    // (207:8) {#if $auth.includes($env)}
    function create_if_block_5(ctx) {
        let current;

        const fielddisabled = new FieldDisabled({
            props: {
                name: "authorization",
                placeholder: "Authorization",
                value: "Bearer " + /*$token*/ ctx[14]
            }
        });

        return {
            c() {
                create_component(fielddisabled.$$.fragment);
            },
            m(target, anchor) {
                mount_component(fielddisabled, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const fielddisabled_changes = {};
                if (dirty[0] & /*$token*/ 16384) fielddisabled_changes.value = "Bearer " + /*$token*/ ctx[14];
                fielddisabled.$set(fielddisabled_changes);
            },
            i(local) {
                if (current) return;
                transition_in(fielddisabled.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(fielddisabled.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(fielddisabled, detaching);
            }
        };
    }

    // (221:6) {:else}
    function create_else_block_1$1(ctx) {
        let each_1_anchor;
        let current;
        let each_value_1 = /*requestParameters*/ ctx[1];
        let each_blocks = [];

        for (let i = 0; i < each_value_1.length; i += 1) {
            each_blocks[i] = create_each_block_1$1(get_each_context_1$1(ctx, each_value_1, i));
        }

        const out = i => transition_out(each_blocks[i], 1, 1, () => {
            each_blocks[i] = null;
        });

        return {
            c() {
                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].c();
                }

                each_1_anchor = empty();
            },
            m(target, anchor) {
                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].m(target, anchor);
                }

                insert(target, each_1_anchor, anchor);
                current = true;
            },
            p(ctx, dirty) {
                if (dirty[0] & /*requestParameters*/ 2) {
                    each_value_1 = /*requestParameters*/ ctx[1];
                    let i;

                    for (i = 0; i < each_value_1.length; i += 1) {
                        const child_ctx = get_each_context_1$1(ctx, each_value_1, i);

                        if (each_blocks[i]) {
                            each_blocks[i].p(child_ctx, dirty);
                            transition_in(each_blocks[i], 1);
                        } else {
                            each_blocks[i] = create_each_block_1$1(child_ctx);
                            each_blocks[i].c();
                            transition_in(each_blocks[i], 1);
                            each_blocks[i].m(each_1_anchor.parentNode, each_1_anchor);
                        }
                    }

                    group_outros();

                    for (i = each_value_1.length; i < each_blocks.length; i += 1) {
                        out(i);
                    }

                    check_outros();
                }
            },
            i(local) {
                if (current) return;

                for (let i = 0; i < each_value_1.length; i += 1) {
                    transition_in(each_blocks[i]);
                }

                current = true;
            },
            o(local) {
                each_blocks = each_blocks.filter(Boolean);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    transition_out(each_blocks[i]);
                }

                current = false;
            },
            d(detaching) {
                destroy_each(each_blocks, detaching);
                if (detaching) detach(each_1_anchor);
            }
        };
    }

    // (217:6) {#if requestParameters.length === 0}
    function create_if_block_3$2(ctx) {
        let p;

        return {
            c() {
                p = element("p");
                p.innerHTML = `<em>No configurable parameters.</em>`;
            },
            m(target, anchor) {
                insert(target, p, anchor);
            },
            p: noop,
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(p);
            }
        };
    }

    // (222:8) {#each requestParameters as param}
    function create_each_block_1$1(ctx) {
        let updating_used;
        let updating_value;
        let current;

        function fieldswitch_used_binding_1(value) {
            /*fieldswitch_used_binding_1*/ ctx[24].call(null, value, /*param*/ ctx[33]);
        }

        function fieldswitch_value_binding_1(value_1) {
            /*fieldswitch_value_binding_1*/ ctx[25].call(null, value_1, /*param*/ ctx[33]);
        }

        let fieldswitch_props = {
            name: /*param*/ ctx[33].name,
            required: /*param*/ ctx[33].required,
            rounded: false
        };

        if (/*param*/ ctx[33].used !== void 0) {
            fieldswitch_props.used = /*param*/ ctx[33].used;
        }

        if (/*param*/ ctx[33].value !== void 0) {
            fieldswitch_props.value = /*param*/ ctx[33].value;
        }

        const fieldswitch = new FieldSwitch({ props: fieldswitch_props });
        binding_callbacks.push(() => bind(fieldswitch, "used", fieldswitch_used_binding_1));
        binding_callbacks.push(() => bind(fieldswitch, "value", fieldswitch_value_binding_1));

        return {
            c() {
                create_component(fieldswitch.$$.fragment);
            },
            m(target, anchor) {
                mount_component(fieldswitch, target, anchor);
                current = true;
            },
            p(new_ctx, dirty) {
                ctx = new_ctx;
                const fieldswitch_changes = {};
                if (dirty[0] & /*requestParameters*/ 2) fieldswitch_changes.name = /*param*/ ctx[33].name;
                if (dirty[0] & /*requestParameters*/ 2) fieldswitch_changes.required = /*param*/ ctx[33].required;

                if (!updating_used && dirty[0] & /*requestParameters*/ 2) {
                    updating_used = true;
                    fieldswitch_changes.used = /*param*/ ctx[33].used;
                    add_flush_callback(() => updating_used = false);
                }

                if (!updating_value && dirty[0] & /*requestParameters*/ 2) {
                    updating_value = true;
                    fieldswitch_changes.value = /*param*/ ctx[33].value;
                    add_flush_callback(() => updating_value = false);
                }

                fieldswitch.$set(fieldswitch_changes);
            },
            i(local) {
                if (current) return;
                transition_in(fieldswitch.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(fieldswitch.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(fieldswitch, detaching);
            }
        };
    }

    // (239:6) {:else}
    function create_else_block$3(ctx) {
        let p;

        return {
            c() {
                p = element("p");
                p.innerHTML = `<i>Body is only available for POST, PUT and PATCH.</i>`;
            },
            m(target, anchor) {
                insert(target, p, anchor);
            },
            p: noop,
            d(detaching) {
                if (detaching) detach(p);
            }
        };
    }

    // (234:6) {#if allowBody(currentAction)}
    function create_if_block_2$4(ctx) {
        let textarea;
        let dispose;

        return {
            c() {
                textarea = element("textarea");
                attr(textarea, "class", "textarea is-family-code");
                attr(textarea, "rows", "8");
                dispose = listen(textarea, "input", /*textarea_input_handler*/ ctx[26]);
            },
            m(target, anchor) {
                insert(target, textarea, anchor);
                set_input_value(textarea, /*requestBody*/ ctx[2]);
            },
            p(ctx, dirty) {
                if (dirty[0] & /*requestBody*/ 4) {
                    set_input_value(textarea, /*requestBody*/ ctx[2]);
                }
            },
            d(detaching) {
                if (detaching) detach(textarea);
                dispose();
            }
        };
    }

    // (279:4) {:catch error}
    function create_catch_block(ctx) {
        let div1;
        let section1;
        let section0;
        let div0;
        let p;
        let t_value = /*error*/ ctx[28] + "";
        let t;

        return {
            c() {
                div1 = element("div");
                section1 = element("section");
                section0 = element("section");
                div0 = element("div");
                p = element("p");
                t = text(t_value);
                attr(p, "class", "subtitle");
                attr(div0, "class", "container");
                attr(section0, "class", "hero-body");
                attr(section1, "class", "hero is-danger");
                attr(div1, "class", "small-section svelte-c3oocm");
            },
            m(target, anchor) {
                insert(target, div1, anchor);
                append(div1, section1);
                append(section1, section0);
                append(section0, div0);
                append(div0, p);
                append(p, t);
            },
            p(ctx, dirty) {
                if (dirty[0] & /*response*/ 128 && t_value !== (t_value = /*error*/ ctx[28] + "")) set_data(t, t_value);
            },
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(div1);
            }
        };
    }

    // (252:4) {:then value}
    function create_then_block(ctx) {
        let show_if = Object.keys(/*value*/ ctx[27] || ({})).length > 0;
        let if_block_anchor;
        let current;
        let if_block = show_if && create_if_block$a(ctx);

        return {
            c() {
                if (if_block) if_block.c();
                if_block_anchor = empty();
            },
            m(target, anchor) {
                if (if_block) if_block.m(target, anchor);
                insert(target, if_block_anchor, anchor);
                current = true;
            },
            p(ctx, dirty) {
                if (dirty[0] & /*response*/ 128) show_if = Object.keys(/*value*/ ctx[27] || ({})).length > 0;

                if (show_if) {
                    if (if_block) {
                        if_block.p(ctx, dirty);
                        transition_in(if_block, 1);
                    } else {
                        if_block = create_if_block$a(ctx);
                        if_block.c();
                        transition_in(if_block, 1);
                        if_block.m(if_block_anchor.parentNode, if_block_anchor);
                    }
                } else if (if_block) {
                    group_outros();

                    transition_out(if_block, 1, 1, () => {
                        if_block = null;
                    });

                    check_outros();
                }
            },
            i(local) {
                if (current) return;
                transition_in(if_block);
                current = true;
            },
            o(local) {
                transition_out(if_block);
                current = false;
            },
            d(detaching) {
                if (if_block) if_block.d(detaching);
                if (detaching) detach(if_block_anchor);
            }
        };
    }

    // (253:6) {#if Object.keys(value || {}).length > 0}
    function create_if_block$a(ctx) {
        let div1;
        let section1;
        let section0;
        let div0;
        let h1;
        let t0_value = /*value*/ ctx[27].status + "";
        let t0;
        let t1;
        let t2_value = /*value*/ ctx[27].statusText + "";
        let t2;
        let section1_class_value;
        let t3;
        let show_if = Object.keys(/*value*/ ctx[27].headers).length > 0;
        let current;
        let if_block = show_if && create_if_block_1$7(ctx);

        return {
            c() {
                div1 = element("div");
                section1 = element("section");
                section0 = element("section");
                div0 = element("div");
                h1 = element("h1");
                t0 = text(t0_value);
                t1 = space();
                t2 = text(t2_value);
                t3 = space();
                if (if_block) if_block.c();
                attr(h1, "class", "title");
                attr(div0, "class", "container has-text-centered");
                attr(section0, "class", "hero-body hero-small svelte-c3oocm");
                attr(section1, "class", section1_class_value = "hero hero-rounded " + colorize(/*value*/ ctx[27].status) + " svelte-c3oocm");
                attr(div1, "class", "small-section svelte-c3oocm");
            },
            m(target, anchor) {
                insert(target, div1, anchor);
                append(div1, section1);
                append(section1, section0);
                append(section0, div0);
                append(div0, h1);
                append(h1, t0);
                append(h1, t1);
                append(h1, t2);
                append(div1, t3);
                if (if_block) if_block.m(div1, null);
                current = true;
            },
            p(ctx, dirty) {
                if ((!current || dirty[0] & /*response*/ 128) && t0_value !== (t0_value = /*value*/ ctx[27].status + "")) set_data(t0, t0_value);
                if ((!current || dirty[0] & /*response*/ 128) && t2_value !== (t2_value = /*value*/ ctx[27].statusText + "")) set_data(t2, t2_value);

                if (!current || dirty[0] & /*response*/ 128 && section1_class_value !== (section1_class_value = "hero hero-rounded " + colorize(/*value*/ ctx[27].status) + " svelte-c3oocm")) {
                    attr(section1, "class", section1_class_value);
                }

                if (dirty[0] & /*response*/ 128) show_if = Object.keys(/*value*/ ctx[27].headers).length > 0;

                if (show_if) {
                    if (if_block) {
                        if_block.p(ctx, dirty);
                        transition_in(if_block, 1);
                    } else {
                        if_block = create_if_block_1$7(ctx);
                        if_block.c();
                        transition_in(if_block, 1);
                        if_block.m(div1, null);
                    }
                } else if (if_block) {
                    group_outros();

                    transition_out(if_block, 1, 1, () => {
                        if_block = null;
                    });

                    check_outros();
                }
            },
            i(local) {
                if (current) return;
                transition_in(if_block);
                current = true;
            },
            o(local) {
                transition_out(if_block);
                current = false;
            },
            d(detaching) {
                if (detaching) detach(div1);
                if (if_block) if_block.d();
            }
        };
    }

    // (263:10) {#if Object.keys(value.headers).length > 0}
    function create_if_block_1$7(ctx) {
        let div1;
        let div0;
        let t;
        let current;
        let each_value = Object.entries(/*value*/ ctx[27].headers);
        let each_blocks = [];

        for (let i = 0; i < each_value.length; i += 1) {
            each_blocks[i] = create_each_block$5(get_each_context$5(ctx, each_value, i));
        }

        const codeblock = new CodeBlock({
            props: {
                type: contentType(/*value*/ ctx[27].headers),
                body: /*value*/ ctx[27].data
            }
        });

        return {
            c() {
                div1 = element("div");
                div0 = element("div");

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].c();
                }

                t = space();
                create_component(codeblock.$$.fragment);
                attr(div0, "class", "content-header svelte-c3oocm");
                attr(div1, "class", "container container-content svelte-c3oocm");
            },
            m(target, anchor) {
                insert(target, div1, anchor);
                append(div1, div0);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].m(div0, null);
                }

                append(div1, t);
                mount_component(codeblock, div1, null);
                current = true;
            },
            p(ctx, dirty) {
                if (dirty[0] & /*response*/ 128) {
                    each_value = Object.entries(/*value*/ ctx[27].headers);
                    let i;

                    for (i = 0; i < each_value.length; i += 1) {
                        const child_ctx = get_each_context$5(ctx, each_value, i);

                        if (each_blocks[i]) {
                            each_blocks[i].p(child_ctx, dirty);
                        } else {
                            each_blocks[i] = create_each_block$5(child_ctx);
                            each_blocks[i].c();
                            each_blocks[i].m(div0, null);
                        }
                    }

                    for (; i < each_blocks.length; i += 1) {
                        each_blocks[i].d(1);
                    }

                    each_blocks.length = each_value.length;
                }

                const codeblock_changes = {};
                if (dirty[0] & /*response*/ 128) codeblock_changes.type = contentType(/*value*/ ctx[27].headers);
                if (dirty[0] & /*response*/ 128) codeblock_changes.body = /*value*/ ctx[27].data;
                codeblock.$set(codeblock_changes);
            },
            i(local) {
                if (current) return;
                transition_in(codeblock.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(codeblock.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                if (detaching) detach(div1);
                destroy_each(each_blocks, detaching);
                destroy_component(codeblock);
            }
        };
    }

    // (266:16) {#each Object.entries(value.headers) as [key, val]}
    function create_each_block$5(ctx) {
        let p;
        let span;
        let t0_value = /*key*/ ctx[29] + "";
        let t0;
        let t1;
        let t2_value = /*val*/ ctx[30] + "";
        let t2;
        let t3;

        return {
            c() {
                p = element("p");
                span = element("span");
                t0 = text(t0_value);
                t1 = text("\n                    : ");
                t2 = text(t2_value);
                t3 = space();
                attr(span, "class", "is-capitalized");
                attr(p, "class", "is-family-code");
            },
            m(target, anchor) {
                insert(target, p, anchor);
                append(p, span);
                append(span, t0);
                append(p, t1);
                append(p, t2);
                append(p, t3);
            },
            p(ctx, dirty) {
                if (dirty[0] & /*response*/ 128 && t0_value !== (t0_value = /*key*/ ctx[29] + "")) set_data(t0, t0_value);
                if (dirty[0] & /*response*/ 128 && t2_value !== (t2_value = /*val*/ ctx[30] + "")) set_data(t2, t2_value);
            },
            d(detaching) {
                if (detaching) detach(p);
            }
        };
    }

    // (246:21)        <div class="section has-text-centered">         <span class="icon is-medium has-text-danger">           <i class="fas fa-2x fa-spinner fa-pulse" />         </span>       </div>     {:then value}
    function create_pending_block(ctx) {
        let div;

        return {
            c() {
                div = element("div");
                div.innerHTML = `<span class="icon is-medium has-text-danger"><i class="fas fa-2x fa-spinner fa-pulse"></i></span>`;
                attr(div, "class", "section has-text-centered");
            },
            m(target, anchor) {
                insert(target, div, anchor);
            },
            p: noop,
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(div);
            }
        };
    }

    // (120:2) <div slot="body">
    function create_body_slot(ctx) {
        let div0;
        let div3;
        let div1;
        let t0;
        let div2;
        let show_if_4;
        let current_block_type_index;
        let if_block1;
        let t1;
        let div4;
        let ul;
        let li0;
        let a0;
        let t3;
        let li1;
        let a1;
        let t5;
        let li2;
        let a2;
        let t7;
        let div5;
        let current_block_type_index_1;
        let if_block2;
        let t8;
        let show_if_3 = isAuth(/*environment*/ ctx[10], "basic");
        let t9;
        let show_if_2 = isAuth(/*environment*/ ctx[10], "apikey");
        let t10;
        let show_if_1 = isAuth(/*environment*/ ctx[10], "oauth2") || isAuth(/*environment*/ ctx[10], "oauth2-pkce");
        let t11;
        let div6;
        let current_block_type_index_2;
        let if_block6;
        let t12;
        let div7;
        let show_if;
        let t13;
        let promise;
        let current;
        let dispose;

        function select_block_type(ctx, dirty) {
            if (/*copying*/ ctx[9]) return create_if_block_10;
            return create_else_block_4;
        }

        let current_block_type = select_block_type(ctx, -1);
        let if_block0 = current_block_type(ctx);
        const if_block_creators = [create_if_block_9, create_else_block_3];
        const if_blocks = [];

        function select_block_type_1(ctx, dirty) {
            if (dirty[0] & /*environment, $auth, $env*/ 11264) show_if_4 = !!((isAuth(/*environment*/ ctx[10], "oauth2") || isAuth(/*environment*/ ctx[10], "oauth2-pkce")) && !/*$auth*/ ctx[13].includes(/*$env*/ ctx[11]));
            if (show_if_4) return 0;
            return 1;
        }

        current_block_type_index = select_block_type_1(ctx, -1);
        if_block1 = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);
        const if_block_creators_1 = [create_if_block_8, create_else_block_2];
        const if_blocks_1 = [];

        function select_block_type_2(ctx, dirty) {
            if (/*requestHeaders*/ ctx[0].length === 0 && !/*environment*/ ctx[10].auth) return 0;
            return 1;
        }

        current_block_type_index_1 = select_block_type_2(ctx, -1);
        if_block2 = if_blocks_1[current_block_type_index_1] = if_block_creators_1[current_block_type_index_1](ctx);
        let if_block3 = show_if_3 && create_if_block_7(ctx);
        let if_block4 = show_if_2 && create_if_block_6(ctx);
        let if_block5 = show_if_1 && create_if_block_4(ctx);
        const if_block_creators_2 = [create_if_block_3$2, create_else_block_1$1];
        const if_blocks_2 = [];

        function select_block_type_3(ctx, dirty) {
            if (/*requestParameters*/ ctx[1].length === 0) return 0;
            return 1;
        }

        current_block_type_index_2 = select_block_type_3(ctx, -1);
        if_block6 = if_blocks_2[current_block_type_index_2] = if_block_creators_2[current_block_type_index_2](ctx);

        function select_block_type_4(ctx, dirty) {
            if (show_if == null || dirty[0] & /*currentAction*/ 32) show_if = !!allowBody(/*currentAction*/ ctx[5]);
            if (show_if) return create_if_block_2$4;
            return create_else_block$3;
        }

        let current_block_type_1 = select_block_type_4(ctx, -1);
        let if_block7 = current_block_type_1(ctx);

        let info = {
            ctx,
            current: null,
            token: null,
            pending: create_pending_block,
            then: create_then_block,
            catch: create_catch_block,
            value: 27,
            error: 28,
            blocks: [,,,]
        };

        handle_promise(promise = /*response*/ ctx[7], info);

        return {
            c() {
                div0 = element("div");
                div3 = element("div");
                div1 = element("div");
                if_block0.c();
                t0 = space();
                div2 = element("div");
                if_block1.c();
                t1 = space();
                div4 = element("div");
                ul = element("ul");
                li0 = element("li");
                a0 = element("a");
                a0.textContent = "Headers";
                t3 = space();
                li1 = element("li");
                a1 = element("a");
                a1.textContent = "Parameters";
                t5 = space();
                li2 = element("li");
                a2 = element("a");
                a2.textContent = "Body";
                t7 = space();
                div5 = element("div");
                if_block2.c();
                t8 = space();
                if (if_block3) if_block3.c();
                t9 = space();
                if (if_block4) if_block4.c();
                t10 = space();
                if (if_block5) if_block5.c();
                t11 = space();
                div6 = element("div");
                if_block6.c();
                t12 = space();
                div7 = element("div");
                if_block7.c();
                t13 = space();
                info.block.c();
                attr(div1, "class", "column");
                attr(div2, "class", "column is-one-fifth");
                attr(div3, "class", "columns");
                attr(a0, "href", "javascript:void(0)");
                toggle_class(li0, "is-active", /*requestTab*/ ctx[8] === 0);
                attr(a1, "href", "javascript:void(0)");
                toggle_class(li1, "is-active", /*requestTab*/ ctx[8] === 1);
                attr(a2, "href", "javascript:void(0)");
                toggle_class(li2, "is-active", /*requestTab*/ ctx[8] === 2);
                attr(div4, "class", "tabs is-boxed");
                attr(div5, "class", "section-headers");
                toggle_class(div5, "is-hidden", /*requestTab*/ ctx[8] != 0);
                attr(div6, "class", "section-parameters");
                toggle_class(div6, "is-hidden", /*requestTab*/ ctx[8] != 1);
                attr(div7, "class", "section-body");
                toggle_class(div7, "is-hidden", /*requestTab*/ ctx[8] != 2);
                attr(div0, "slot", "body");

                dispose = [
                    listen(a0, "click", /*click_handler*/ ctx[19]),
                    listen(a1, "click", /*click_handler_1*/ ctx[20]),
                    listen(a2, "click", /*click_handler_2*/ ctx[21])
                ];
            },
            m(target, anchor) {
                insert(target, div0, anchor);
                append(div0, div3);
                append(div3, div1);
                if_block0.m(div1, null);
                append(div3, t0);
                append(div3, div2);
                if_blocks[current_block_type_index].m(div2, null);
                append(div0, t1);
                append(div0, div4);
                append(div4, ul);
                append(ul, li0);
                append(li0, a0);
                append(ul, t3);
                append(ul, li1);
                append(li1, a1);
                append(ul, t5);
                append(ul, li2);
                append(li2, a2);
                append(div0, t7);
                append(div0, div5);
                if_blocks_1[current_block_type_index_1].m(div5, null);
                append(div5, t8);
                if (if_block3) if_block3.m(div5, null);
                append(div5, t9);
                if (if_block4) if_block4.m(div5, null);
                append(div5, t10);
                if (if_block5) if_block5.m(div5, null);
                append(div0, t11);
                append(div0, div6);
                if_blocks_2[current_block_type_index_2].m(div6, null);
                append(div0, t12);
                append(div0, div7);
                if_block7.m(div7, null);
                append(div0, t13);
                info.block.m(div0, info.anchor = null);
                info.mount = () => div0;
                info.anchor = null;
                current = true;
            },
            p(new_ctx, dirty) {
                ctx = new_ctx;

                if (current_block_type === (current_block_type = select_block_type(ctx, dirty)) && if_block0) {
                    if_block0.p(ctx, dirty);
                } else {
                    if_block0.d(1);
                    if_block0 = current_block_type(ctx);

                    if (if_block0) {
                        if_block0.c();
                        if_block0.m(div1, null);
                    }
                }

                let previous_block_index = current_block_type_index;
                current_block_type_index = select_block_type_1(ctx, dirty);

                if (current_block_type_index === previous_block_index) {
                    if_blocks[current_block_type_index].p(ctx, dirty);
                } else {
                    group_outros();

                    transition_out(if_blocks[previous_block_index], 1, 1, () => {
                        if_blocks[previous_block_index] = null;
                    });

                    check_outros();
                    if_block1 = if_blocks[current_block_type_index];

                    if (!if_block1) {
                        if_block1 = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);
                        if_block1.c();
                    }

                    transition_in(if_block1, 1);
                    if_block1.m(div2, null);
                }

                if (dirty[0] & /*requestTab*/ 256) {
                    toggle_class(li0, "is-active", /*requestTab*/ ctx[8] === 0);
                }

                if (dirty[0] & /*requestTab*/ 256) {
                    toggle_class(li1, "is-active", /*requestTab*/ ctx[8] === 1);
                }

                if (dirty[0] & /*requestTab*/ 256) {
                    toggle_class(li2, "is-active", /*requestTab*/ ctx[8] === 2);
                }

                let previous_block_index_1 = current_block_type_index_1;
                current_block_type_index_1 = select_block_type_2(ctx, dirty);

                if (current_block_type_index_1 === previous_block_index_1) {
                    if_blocks_1[current_block_type_index_1].p(ctx, dirty);
                } else {
                    group_outros();

                    transition_out(if_blocks_1[previous_block_index_1], 1, 1, () => {
                        if_blocks_1[previous_block_index_1] = null;
                    });

                    check_outros();
                    if_block2 = if_blocks_1[current_block_type_index_1];

                    if (!if_block2) {
                        if_block2 = if_blocks_1[current_block_type_index_1] = if_block_creators_1[current_block_type_index_1](ctx);
                        if_block2.c();
                    }

                    transition_in(if_block2, 1);
                    if_block2.m(div5, t8);
                }

                if (dirty[0] & /*environment*/ 1024) show_if_3 = isAuth(/*environment*/ ctx[10], "basic");

                if (show_if_3) {
                    if (if_block3) {
                        if_block3.p(ctx, dirty);
                        transition_in(if_block3, 1);
                    } else {
                        if_block3 = create_if_block_7(ctx);
                        if_block3.c();
                        transition_in(if_block3, 1);
                        if_block3.m(div5, t9);
                    }
                } else if (if_block3) {
                    group_outros();

                    transition_out(if_block3, 1, 1, () => {
                        if_block3 = null;
                    });

                    check_outros();
                }

                if (dirty[0] & /*environment*/ 1024) show_if_2 = isAuth(/*environment*/ ctx[10], "apikey");

                if (show_if_2) {
                    if (if_block4) {
                        if_block4.p(ctx, dirty);
                        transition_in(if_block4, 1);
                    } else {
                        if_block4 = create_if_block_6(ctx);
                        if_block4.c();
                        transition_in(if_block4, 1);
                        if_block4.m(div5, t10);
                    }
                } else if (if_block4) {
                    group_outros();

                    transition_out(if_block4, 1, 1, () => {
                        if_block4 = null;
                    });

                    check_outros();
                }

                if (dirty[0] & /*environment*/ 1024) show_if_1 = isAuth(/*environment*/ ctx[10], "oauth2") || isAuth(/*environment*/ ctx[10], "oauth2-pkce");

                if (show_if_1) {
                    if (if_block5) {
                        if_block5.p(ctx, dirty);
                        transition_in(if_block5, 1);
                    } else {
                        if_block5 = create_if_block_4(ctx);
                        if_block5.c();
                        transition_in(if_block5, 1);
                        if_block5.m(div5, null);
                    }
                } else if (if_block5) {
                    group_outros();

                    transition_out(if_block5, 1, 1, () => {
                        if_block5 = null;
                    });

                    check_outros();
                }

                if (dirty[0] & /*requestTab*/ 256) {
                    toggle_class(div5, "is-hidden", /*requestTab*/ ctx[8] != 0);
                }

                let previous_block_index_2 = current_block_type_index_2;
                current_block_type_index_2 = select_block_type_3(ctx, dirty);

                if (current_block_type_index_2 === previous_block_index_2) {
                    if_blocks_2[current_block_type_index_2].p(ctx, dirty);
                } else {
                    group_outros();

                    transition_out(if_blocks_2[previous_block_index_2], 1, 1, () => {
                        if_blocks_2[previous_block_index_2] = null;
                    });

                    check_outros();
                    if_block6 = if_blocks_2[current_block_type_index_2];

                    if (!if_block6) {
                        if_block6 = if_blocks_2[current_block_type_index_2] = if_block_creators_2[current_block_type_index_2](ctx);
                        if_block6.c();
                    }

                    transition_in(if_block6, 1);
                    if_block6.m(div6, null);
                }

                if (dirty[0] & /*requestTab*/ 256) {
                    toggle_class(div6, "is-hidden", /*requestTab*/ ctx[8] != 1);
                }

                if (current_block_type_1 === (current_block_type_1 = select_block_type_4(ctx, dirty)) && if_block7) {
                    if_block7.p(ctx, dirty);
                } else {
                    if_block7.d(1);
                    if_block7 = current_block_type_1(ctx);

                    if (if_block7) {
                        if_block7.c();
                        if_block7.m(div7, null);
                    }
                }

                if (dirty[0] & /*requestTab*/ 256) {
                    toggle_class(div7, "is-hidden", /*requestTab*/ ctx[8] != 2);
                }

                info.ctx = ctx;

                if (dirty[0] & /*response*/ 128 && promise !== (promise = /*response*/ ctx[7]) && handle_promise(promise, info)) {

                } else {
                    const child_ctx = ctx.slice();
                    child_ctx[27] = info.resolved;
                    info.block.p(child_ctx, dirty);
                }
            },
            i(local) {
                if (current) return;
                transition_in(if_block1);
                transition_in(if_block2);
                transition_in(if_block3);
                transition_in(if_block4);
                transition_in(if_block5);
                transition_in(if_block6);
                transition_in(info.block);
                current = true;
            },
            o(local) {
                transition_out(if_block1);
                transition_out(if_block2);
                transition_out(if_block3);
                transition_out(if_block4);
                transition_out(if_block5);
                transition_out(if_block6);

                for (let i = 0; i < 3; i += 1) {
                    const block = info.blocks[i];
                    transition_out(block);
                }

                current = false;
            },
            d(detaching) {
                if (detaching) detach(div0);
                if_block0.d();
                if_blocks[current_block_type_index].d();
                if_blocks_1[current_block_type_index_1].d();
                if (if_block3) if_block3.d();
                if (if_block4) if_block4.d();
                if (if_block5) if_block5.d();
                if_blocks_2[current_block_type_index_2].d();
                if_block7.d();
                info.block.d();
                info.token = null;
                info = null;
                run_all(dispose);
            }
        };
    }

    // (118:0) <CollapsiblePanel dark={true} {isDarkmode} {show}>
    function create_default_slot(ctx) {
        let t;
        let current;

        return {
            c() {
                t = space();
            },
            m(target, anchor) {
                insert(target, t, anchor);
            },
            p: noop,
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(t);
            }
        };
    }

    function create_fragment$g(ctx) {
        let current;

        const collapsiblepanel = new CollapsiblePanel({
            props: {
                dark: true,
                isDarkmode: /*isDarkmode*/ ctx[4],
                show: /*show*/ ctx[3],
                $$slots: {
                    default: [create_default_slot],
                    body: [create_body_slot],
                    heading: [create_heading_slot]
                },
                $$scope: { ctx }
            }
        });

        return {
            c() {
                create_component(collapsiblepanel.$$.fragment);
            },
            m(target, anchor) {
                mount_component(collapsiblepanel, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const collapsiblepanel_changes = {};
                if (dirty[0] & /*isDarkmode*/ 16) collapsiblepanel_changes.isDarkmode = /*isDarkmode*/ ctx[4];
                if (dirty[0] & /*show*/ 8) collapsiblepanel_changes.show = /*show*/ ctx[3];

                if (dirty[0] & /*response, requestTab, currentAction, requestBody, requestParameters, environment, $auth, $env, $token, requestHeaders, pkceChallenge, copying, currentUrl*/ 32743 | dirty[1] & /*$$scope*/ 256) {
                    collapsiblepanel_changes.$$scope = { dirty, ctx };
                }

                collapsiblepanel.$set(collapsiblepanel_changes);
            },
            i(local) {
                if (current) return;
                transition_in(collapsiblepanel.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(collapsiblepanel.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(collapsiblepanel, detaching);
            }
        };
    }

    function contentType(headers) {
        return headers && headers["content-type"];
    }

    function basicAuth(username, password) {
        return btoa(`${username}:${password}`);
    }

    function instance$g($$self, $$props, $$invalidate) {
        let $env;
        let $auth;
        let $token;
        component_subscribe($$self, env, $$value => $$invalidate(11, $env = $$value));
        component_subscribe($$self, auth, $$value => $$invalidate(13, $auth = $$value));
        component_subscribe($$self, token, $$value => $$invalidate(14, $token = $$value));
        let { show = true } = $$props;
        let { isDarkmode } = $$props;
        let { environments } = $$props;
        let { currentAction } = $$props;
        let { requestHeaders } = $$props;
        let { requestParameters } = $$props;
        let { requestBody } = $$props;
        let { pkceChallenge } = $$props;
        let response;
        let requestTab = 0;
        let copying = false;

        function handleClick() {
            $$invalidate(7, response = sendRequest($env, environment, currentAction, {
                headers: requestHeaders,
                parameters: requestParameters,
                body: requestBody
            }));
        }

        function handleTab(index) {
            $$invalidate(8, requestTab = index);
        }

        function handleCopy() {
            $$invalidate(9, copying = true);

            setTimeout(
                () => {
                    $$invalidate(9, copying = false);
                },
                2000
            );

            copyUrl(currentUrl, requestParameters);
        }

        beforeUpdate(() => {
            const hash = location.hash.replace("#/", "");
            if (hash !== currentAction.slug) $$invalidate(7, response = undefined);
        });

        const click_handler = () => handleTab(0);
        const click_handler_1 = () => handleTab(1);
        const click_handler_2 = () => handleTab(2);

        function fieldswitch_used_binding(value, header) {
            header.used = value;
            $$invalidate(0, requestHeaders);
        }

        function fieldswitch_value_binding(value_1, header) {
            header.value = value_1;
            $$invalidate(0, requestHeaders);
        }

        function fieldswitch_used_binding_1(value, param) {
            param.used = value;
            $$invalidate(1, requestParameters);
        }

        function fieldswitch_value_binding_1(value_1, param) {
            param.value = value_1;
            $$invalidate(1, requestParameters);
        }

        function textarea_input_handler() {
            requestBody = this.value;
            $$invalidate(2, requestBody);
        }

        $$self.$set = $$props => {
            if ("show" in $$props) $$invalidate(3, show = $$props.show);
            if ("isDarkmode" in $$props) $$invalidate(4, isDarkmode = $$props.isDarkmode);
            if ("environments" in $$props) $$invalidate(18, environments = $$props.environments);
            if ("currentAction" in $$props) $$invalidate(5, currentAction = $$props.currentAction);
            if ("requestHeaders" in $$props) $$invalidate(0, requestHeaders = $$props.requestHeaders);
            if ("requestParameters" in $$props) $$invalidate(1, requestParameters = $$props.requestParameters);
            if ("requestBody" in $$props) $$invalidate(2, requestBody = $$props.requestBody);
            if ("pkceChallenge" in $$props) $$invalidate(6, pkceChallenge = $$props.pkceChallenge);
        };

        let environment;
        let currentUrl;

        $$self.$$.update = () => {
            if ($$self.$$.dirty[0] & /*environments, $env*/ 264192) {
                $$invalidate(10, environment = environments[$env]);
            }

            if ($$self.$$.dirty[0] & /*environment, currentAction*/ 1056) {
                $$invalidate(12, currentUrl = urlParse(urlJoin(environment.url, currentAction.path)));
            }
        };

        return [
            requestHeaders,
            requestParameters,
            requestBody,
            show,
            isDarkmode,
            currentAction,
            pkceChallenge,
            response,
            requestTab,
            copying,
            environment,
            $env,
            currentUrl,
            $auth,
            $token,
            handleClick,
            handleTab,
            handleCopy,
            environments,
            click_handler,
            click_handler_1,
            click_handler_2,
            fieldswitch_used_binding,
            fieldswitch_value_binding,
            fieldswitch_used_binding_1,
            fieldswitch_value_binding_1,
            textarea_input_handler
        ];
    }

    class PlaygroundPanel extends SvelteComponent {
        constructor(options) {
            super();
            if (!document.getElementById("svelte-c3oocm-style")) add_css$8();

            init(
                this,
                options,
                instance$g,
                create_fragment$g,
                safe_not_equal,
                {
                    show: 3,
                    isDarkmode: 4,
                    environments: 18,
                    currentAction: 5,
                    requestHeaders: 0,
                    requestParameters: 1,
                    requestBody: 2,
                    pkceChallenge: 6
                },
                [-1, -1]
            );
        }
    }

    /* app/templates/winter/panels/ScenarioPanel.svelte generated by Svelte v3.16.5 */

    function get_each_context_1$2(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[7] = list[i];
        child_ctx[4] = i;
        return child_ctx;
    }

    function get_each_context$6(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[7] = list[i];
        child_ctx[4] = i;
        return child_ctx;
    }

    // (50:0) {:else}
    function create_else_block$4(ctx) {
        let current;

        const collapsiblepanel = new CollapsiblePanel({
            props: {
                isDarkmode: /*isDarkmode*/ ctx[3],
                show: /*show*/ ctx[0],
                $$slots: {
                    default: [create_default_slot$1],
                    body: [create_body_slot$1],
                    heading: [create_heading_slot$1]
                },
                $$scope: { ctx }
            }
        });

        return {
            c() {
                create_component(collapsiblepanel.$$.fragment);
            },
            m(target, anchor) {
                mount_component(collapsiblepanel, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const collapsiblepanel_changes = {};
                if (dirty & /*isDarkmode*/ 8) collapsiblepanel_changes.isDarkmode = /*isDarkmode*/ ctx[3];
                if (dirty & /*show*/ 1) collapsiblepanel_changes.show = /*show*/ ctx[0];

                if (dirty & /*$$scope, responses, request, index*/ 1046) {
                    collapsiblepanel_changes.$$scope = { dirty, ctx };
                }

                collapsiblepanel.$set(collapsiblepanel_changes);
            },
            i(local) {
                if (current) return;
                transition_in(collapsiblepanel.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(collapsiblepanel.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(collapsiblepanel, detaching);
            }
        };
    }

    // (30:0) {#if request.title === ''}
    function create_if_block$b(ctx) {
        let t0;
        let t1;
        let div;
        let current;
        let if_block = /*show*/ ctx[0] && create_if_block_1$8(ctx);
        let each_value = /*responses*/ ctx[2];
        let each_blocks = [];

        for (let i = 0; i < each_value.length; i += 1) {
            each_blocks[i] = create_each_block$6(get_each_context$6(ctx, each_value, i));
        }

        const out = i => transition_out(each_blocks[i], 1, 1, () => {
            each_blocks[i] = null;
        });

        return {
            c() {
                if (if_block) if_block.c();
                t0 = space();

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].c();
                }

                t1 = space();
                div = element("div");
                attr(div, "class", "panel");
            },
            m(target, anchor) {
                if (if_block) if_block.m(target, anchor);
                insert(target, t0, anchor);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].m(target, anchor);
                }

                insert(target, t1, anchor);
                insert(target, div, anchor);
                current = true;
            },
            p(ctx, dirty) {
                if (/*show*/ ctx[0]) {
                    if (if_block) {
                        if_block.p(ctx, dirty);
                        transition_in(if_block, 1);
                    } else {
                        if_block = create_if_block_1$8(ctx);
                        if_block.c();
                        transition_in(if_block, 1);
                        if_block.m(t0.parentNode, t0);
                    }
                } else if (if_block) {
                    group_outros();

                    transition_out(if_block, 1, 1, () => {
                        if_block = null;
                    });

                    check_outros();
                }

                if (dirty & /*responses*/ 4) {
                    each_value = /*responses*/ ctx[2];
                    let i;

                    for (i = 0; i < each_value.length; i += 1) {
                        const child_ctx = get_each_context$6(ctx, each_value, i);

                        if (each_blocks[i]) {
                            each_blocks[i].p(child_ctx, dirty);
                            transition_in(each_blocks[i], 1);
                        } else {
                            each_blocks[i] = create_each_block$6(child_ctx);
                            each_blocks[i].c();
                            transition_in(each_blocks[i], 1);
                            each_blocks[i].m(t1.parentNode, t1);
                        }
                    }

                    group_outros();

                    for (i = each_value.length; i < each_blocks.length; i += 1) {
                        out(i);
                    }

                    check_outros();
                }
            },
            i(local) {
                if (current) return;
                transition_in(if_block);

                for (let i = 0; i < each_value.length; i += 1) {
                    transition_in(each_blocks[i]);
                }

                current = true;
            },
            o(local) {
                transition_out(if_block);
                each_blocks = each_blocks.filter(Boolean);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    transition_out(each_blocks[i]);
                }

                current = false;
            },
            d(detaching) {
                if (if_block) if_block.d(detaching);
                if (detaching) detach(t0);
                destroy_each(each_blocks, detaching);
                if (detaching) detach(t1);
                if (detaching) detach(div);
            }
        };
    }

    // (52:4) <span slot="heading">
    function create_heading_slot$1(ctx) {
        let span;
        let t_value = /*title*/ ctx[5](/*index*/ ctx[4]) + "";
        let t;

        return {
            c() {
                span = element("span");
                t = text(t_value);
                attr(span, "slot", "heading");
            },
            m(target, anchor) {
                insert(target, span, anchor);
                append(span, t);
            },
            p(ctx, dirty) {
                if (dirty & /*index*/ 16 && t_value !== (t_value = /*title*/ ctx[5](/*index*/ ctx[4]) + "")) set_data(t, t_value);
            },
            d(detaching) {
                if (detaching) detach(span);
            }
        };
    }

    // (61:6) {#each responses as response, index}
    function create_each_block_1$2(ctx) {
        let current;

        const responsepanel = new ResponsePanel({
            props: {
                title: /*response*/ ctx[7].title,
                description: /*response*/ ctx[7].description,
                statusCode: /*response*/ ctx[7].statusCode,
                headers: /*response*/ ctx[7].headers,
                contentType: /*response*/ ctx[7].contentType,
                example: /*response*/ ctx[7].example,
                schema: /*response*/ ctx[7].schema
            }
        });

        return {
            c() {
                create_component(responsepanel.$$.fragment);
            },
            m(target, anchor) {
                mount_component(responsepanel, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const responsepanel_changes = {};
                if (dirty & /*responses*/ 4) responsepanel_changes.title = /*response*/ ctx[7].title;
                if (dirty & /*responses*/ 4) responsepanel_changes.description = /*response*/ ctx[7].description;
                if (dirty & /*responses*/ 4) responsepanel_changes.statusCode = /*response*/ ctx[7].statusCode;
                if (dirty & /*responses*/ 4) responsepanel_changes.headers = /*response*/ ctx[7].headers;
                if (dirty & /*responses*/ 4) responsepanel_changes.contentType = /*response*/ ctx[7].contentType;
                if (dirty & /*responses*/ 4) responsepanel_changes.example = /*response*/ ctx[7].example;
                if (dirty & /*responses*/ 4) responsepanel_changes.schema = /*response*/ ctx[7].schema;
                responsepanel.$set(responsepanel_changes);
            },
            i(local) {
                if (current) return;
                transition_in(responsepanel.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(responsepanel.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(responsepanel, detaching);
            }
        };
    }

    // (53:4) <div slot="body">
    function create_body_slot$1(ctx) {
        let div;
        let t;
        let current;

        const requestpanel = new RequestPanel({
            props: {
                description: /*request*/ ctx[1].description,
                headers: /*request*/ ctx[1].headers,
                contentType: /*request*/ ctx[1].contentType,
                example: /*request*/ ctx[1].example,
                schema: /*request*/ ctx[1].schema
            }
        });

        let each_value_1 = /*responses*/ ctx[2];
        let each_blocks = [];

        for (let i = 0; i < each_value_1.length; i += 1) {
            each_blocks[i] = create_each_block_1$2(get_each_context_1$2(ctx, each_value_1, i));
        }

        const out = i => transition_out(each_blocks[i], 1, 1, () => {
            each_blocks[i] = null;
        });

        return {
            c() {
                div = element("div");
                create_component(requestpanel.$$.fragment);
                t = space();

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].c();
                }

                attr(div, "slot", "body");
            },
            m(target, anchor) {
                insert(target, div, anchor);
                mount_component(requestpanel, div, null);
                append(div, t);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].m(div, null);
                }

                current = true;
            },
            p(ctx, dirty) {
                const requestpanel_changes = {};
                if (dirty & /*request*/ 2) requestpanel_changes.description = /*request*/ ctx[1].description;
                if (dirty & /*request*/ 2) requestpanel_changes.headers = /*request*/ ctx[1].headers;
                if (dirty & /*request*/ 2) requestpanel_changes.contentType = /*request*/ ctx[1].contentType;
                if (dirty & /*request*/ 2) requestpanel_changes.example = /*request*/ ctx[1].example;
                if (dirty & /*request*/ 2) requestpanel_changes.schema = /*request*/ ctx[1].schema;
                requestpanel.$set(requestpanel_changes);

                if (dirty & /*responses*/ 4) {
                    each_value_1 = /*responses*/ ctx[2];
                    let i;

                    for (i = 0; i < each_value_1.length; i += 1) {
                        const child_ctx = get_each_context_1$2(ctx, each_value_1, i);

                        if (each_blocks[i]) {
                            each_blocks[i].p(child_ctx, dirty);
                            transition_in(each_blocks[i], 1);
                        } else {
                            each_blocks[i] = create_each_block_1$2(child_ctx);
                            each_blocks[i].c();
                            transition_in(each_blocks[i], 1);
                            each_blocks[i].m(div, null);
                        }
                    }

                    group_outros();

                    for (i = each_value_1.length; i < each_blocks.length; i += 1) {
                        out(i);
                    }

                    check_outros();
                }
            },
            i(local) {
                if (current) return;
                transition_in(requestpanel.$$.fragment, local);

                for (let i = 0; i < each_value_1.length; i += 1) {
                    transition_in(each_blocks[i]);
                }

                current = true;
            },
            o(local) {
                transition_out(requestpanel.$$.fragment, local);
                each_blocks = each_blocks.filter(Boolean);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    transition_out(each_blocks[i]);
                }

                current = false;
            },
            d(detaching) {
                if (detaching) detach(div);
                destroy_component(requestpanel);
                destroy_each(each_blocks, detaching);
            }
        };
    }

    // (51:2) <CollapsiblePanel {isDarkmode} {show}>
    function create_default_slot$1(ctx) {
        let t;
        let current;

        return {
            c() {
                t = space();
            },
            m(target, anchor) {
                insert(target, t, anchor);
            },
            p: noop,
            i: noop,
            o: noop,
            d(detaching) {
                if (detaching) detach(t);
            }
        };
    }

    // (31:2) {#if show}
    function create_if_block_1$8(ctx) {
        let current;

        const requestpanel = new RequestPanel({
            props: {
                description: /*request*/ ctx[1].description,
                headers: /*request*/ ctx[1].headers,
                contentType: /*request*/ ctx[1].contentType,
                example: /*request*/ ctx[1].example,
                schema: /*request*/ ctx[1].schema
            }
        });

        return {
            c() {
                create_component(requestpanel.$$.fragment);
            },
            m(target, anchor) {
                mount_component(requestpanel, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const requestpanel_changes = {};
                if (dirty & /*request*/ 2) requestpanel_changes.description = /*request*/ ctx[1].description;
                if (dirty & /*request*/ 2) requestpanel_changes.headers = /*request*/ ctx[1].headers;
                if (dirty & /*request*/ 2) requestpanel_changes.contentType = /*request*/ ctx[1].contentType;
                if (dirty & /*request*/ 2) requestpanel_changes.example = /*request*/ ctx[1].example;
                if (dirty & /*request*/ 2) requestpanel_changes.schema = /*request*/ ctx[1].schema;
                requestpanel.$set(requestpanel_changes);
            },
            i(local) {
                if (current) return;
                transition_in(requestpanel.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(requestpanel.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(requestpanel, detaching);
            }
        };
    }

    // (39:2) {#each responses as response, index}
    function create_each_block$6(ctx) {
        let current;

        const responsepanel = new ResponsePanel({
            props: {
                title: /*response*/ ctx[7].title,
                description: /*response*/ ctx[7].description,
                statusCode: /*response*/ ctx[7].statusCode,
                headers: /*response*/ ctx[7].headers,
                contentType: /*response*/ ctx[7].contentType,
                example: /*response*/ ctx[7].example,
                schema: /*response*/ ctx[7].schema
            }
        });

        return {
            c() {
                create_component(responsepanel.$$.fragment);
            },
            m(target, anchor) {
                mount_component(responsepanel, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const responsepanel_changes = {};
                if (dirty & /*responses*/ 4) responsepanel_changes.title = /*response*/ ctx[7].title;
                if (dirty & /*responses*/ 4) responsepanel_changes.description = /*response*/ ctx[7].description;
                if (dirty & /*responses*/ 4) responsepanel_changes.statusCode = /*response*/ ctx[7].statusCode;
                if (dirty & /*responses*/ 4) responsepanel_changes.headers = /*response*/ ctx[7].headers;
                if (dirty & /*responses*/ 4) responsepanel_changes.contentType = /*response*/ ctx[7].contentType;
                if (dirty & /*responses*/ 4) responsepanel_changes.example = /*response*/ ctx[7].example;
                if (dirty & /*responses*/ 4) responsepanel_changes.schema = /*response*/ ctx[7].schema;
                responsepanel.$set(responsepanel_changes);
            },
            i(local) {
                if (current) return;
                transition_in(responsepanel.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(responsepanel.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(responsepanel, detaching);
            }
        };
    }

    function create_fragment$h(ctx) {
        let current_block_type_index;
        let if_block;
        let if_block_anchor;
        let current;
        const if_block_creators = [create_if_block$b, create_else_block$4];
        const if_blocks = [];

        function select_block_type(ctx, dirty) {
            if (/*request*/ ctx[1].title === "") return 0;
            return 1;
        }

        current_block_type_index = select_block_type(ctx, -1);
        if_block = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);

        return {
            c() {
                if_block.c();
                if_block_anchor = empty();
            },
            m(target, anchor) {
                if_blocks[current_block_type_index].m(target, anchor);
                insert(target, if_block_anchor, anchor);
                current = true;
            },
            p(ctx, [dirty]) {
                let previous_block_index = current_block_type_index;
                current_block_type_index = select_block_type(ctx, dirty);

                if (current_block_type_index === previous_block_index) {
                    if_blocks[current_block_type_index].p(ctx, dirty);
                } else {
                    group_outros();

                    transition_out(if_blocks[previous_block_index], 1, 1, () => {
                        if_blocks[previous_block_index] = null;
                    });

                    check_outros();
                    if_block = if_blocks[current_block_type_index];

                    if (!if_block) {
                        if_block = if_blocks[current_block_type_index] = if_block_creators[current_block_type_index](ctx);
                        if_block.c();
                    }

                    transition_in(if_block, 1);
                    if_block.m(if_block_anchor.parentNode, if_block_anchor);
                }
            },
            i(local) {
                if (current) return;
                transition_in(if_block);
                current = true;
            },
            o(local) {
                transition_out(if_block);
                current = false;
            },
            d(detaching) {
                if_blocks[current_block_type_index].d(detaching);
                if (detaching) detach(if_block_anchor);
            }
        };
    }

    function instance$h($$self, $$props, $$invalidate) {
        let { show } = $$props;
        let { count } = $$props;
        let { index } = $$props;
        let { request } = $$props;
        let { responses } = $$props;
        let { isDarkmode } = $$props;

        function title(index) {
            if (request.title) {
                return `Request ${request.title}`;
            }

            if (count === 1) {
                return "Request";
            } else {
                return `Request ${index + 1}`;
            }
        }

        $$self.$set = $$props => {
            if ("show" in $$props) $$invalidate(0, show = $$props.show);
            if ("count" in $$props) $$invalidate(6, count = $$props.count);
            if ("index" in $$props) $$invalidate(4, index = $$props.index);
            if ("request" in $$props) $$invalidate(1, request = $$props.request);
            if ("responses" in $$props) $$invalidate(2, responses = $$props.responses);
            if ("isDarkmode" in $$props) $$invalidate(3, isDarkmode = $$props.isDarkmode);
        };

        return [show, request, responses, isDarkmode, index, title, count];
    }

    class ScenarioPanel extends SvelteComponent {
        constructor(options) {
            super();

            init(this, options, instance$h, create_fragment$h, safe_not_equal, {
                show: 0,
                count: 6,
                index: 4,
                request: 1,
                responses: 2,
                isDarkmode: 3
            });
        }
    }

    /* app/templates/winter.svelte generated by Svelte v3.16.5 */

    const { document: document_1 } = globals;

    function add_css$9() {
        var style = element("style");
        style.id = "svelte-1jcck2f-style";
        style.textContent = "html{height:100%}body{min-height:100%}.sidenav.svelte-1jcck2f{padding:1rem 0 1rem 0.75rem}.main.svelte-1jcck2f{padding:3rem;background-color:#fff;box-shadow:0 2px 0 2px #f5f5f5}.main.is-darkmode.svelte-1jcck2f{background-color:#000;box-shadow:0 2px 0 2px #363636}.breadcrumb-right.svelte-1jcck2f{margin-top:0.3em}.box-wrapper.svelte-1jcck2f{border-radius:0}.body-inner.svelte-1jcck2f{min-height:100vh;background-color:#fafafa}.body-inner.is-darkmode.svelte-1jcck2f{background-color:#000}.is-darkmode .input, .is-darkmode .select select, .is-darkmode\n      .textarea{background-color:#484848;border-color:#484848;color:#fff}.is-darkmode .input:hover, .is-darkmode\n      .is-hovered.input, .is-darkmode .is-hovered.textarea, .is-darkmode\n      .select\n      select.is-hovered, .is-darkmode .select select:hover, .is-darkmode\n      .textarea:hover{border-color:#666}.is-darkmode .select select.is-focused, .is-darkmode\n      .select\n      select:active, .is-darkmode .select select:focus, .is-darkmode\n      .textarea:active, .is-darkmode .textarea:focus{border-color:#888}.is-darkmode .input::placeholder, .is-darkmode\n      .select\n      select::placeholder, .is-darkmode .textarea::placeholder{color:#ccc}code[class*=\"language-\"], pre[class*=\"language-\"]{font-family:monospace}.token.number, .token.tag{display:inline;padding:inherit;font-size:inherit;line-height:inherit;text-align:inherit;vertical-align:inherit;border-radius:inherit;font-weight:inherit;white-space:inherit;background:inherit;margin:inherit}.icon-brand.svelte-1jcck2f{margin-right:0.5rem}.menu-collapsible.svelte-1jcck2f{display:none;position:fixed;width:calc(25% - 0.5rem);height:calc(2.5rem + 10px);left:0;bottom:0;font-size:1.33333em;line-height:calc(2.5rem + 5px);text-align:center;color:#b5b5b5;font-weight:300;border-top:1px solid #eee;box-shadow:2px 0 0 #f5f5f5;cursor:pointer}.menu-collapsible.svelte-1jcck2f:hover{background:rgba(0, 0, 0, 0.05);box-shadow:2px 0 0 #eee;border-color:#e8e8e8}.menu-collapsible.is-darkmode.svelte-1jcck2f{border-color:#363636;box-shadow:2px 0 0 #363636}.menu-collapsible.is-darkmode.svelte-1jcck2f:hover{background:rgba(255, 255, 255, 0.2);border-color:#363636;box-shadow:2px 0 0 #363636}.footer.is-darkmode.svelte-1jcck2f{background-color:#000}.footer.svelte-1jcck2f .content.svelte-1jcck2f{transition:margin 0.3s}@media screen and (min-width: 768px){.menu-collapsible.svelte-1jcck2f{display:block}.is-collapsed.svelte-1jcck2f .sidenav.svelte-1jcck2f{width:3.75rem}.is-collapsed.svelte-1jcck2f .main.svelte-1jcck2f{width:calc(100% - 4.5rem)}.is-collapsed.svelte-1jcck2f .menu-collapsible.svelte-1jcck2f{width:calc(3rem - 2px)}.menu-collapsible.svelte-1jcck2f,.sidenav.svelte-1jcck2f,.main.svelte-1jcck2f{transition:width 0.3s}}";
        append(document_1.head, style);
    }

    function get_each_context$7(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[27] = list[i].request;
        child_ctx[28] = list[i].responses;
        child_ctx[13] = i;
        return child_ctx;
    }

    function get_each_context_1$3(ctx, list, i) {
        const child_ctx = ctx.slice();
        child_ctx[30] = list[i];
        child_ctx[13] = i;
        return child_ctx;
    }

    // (513:8) {#if config.playground.enabled}
    function create_if_block_8$1(ctx) {
        let current;

        const selectorpanel = new SelectorPanel({
            props: {
                environments: /*config*/ ctx[4].playground.environments,
                pkceChallenge: /*challengePair*/ ctx[14],
                authenticating: /*authenticating*/ ctx[7]
            }
        });

        return {
            c() {
                create_component(selectorpanel.$$.fragment);
            },
            m(target, anchor) {
                mount_component(selectorpanel, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const selectorpanel_changes = {};
                if (dirty[0] & /*config*/ 16) selectorpanel_changes.environments = /*config*/ ctx[4].playground.environments;
                if (dirty[0] & /*authenticating*/ 128) selectorpanel_changes.authenticating = /*authenticating*/ ctx[7];
                selectorpanel.$set(selectorpanel_changes);
            },
            i(local) {
                if (current) return;
                transition_in(selectorpanel.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(selectorpanel.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(selectorpanel, detaching);
            }
        };
    }

    // (519:8) {#if darkMode.enable}
    function create_if_block_7$1(ctx) {
        let div;
        let a;
        let span;
        let i;
        let dispose;

        return {
            c() {
                div = element("div");
                a = element("a");
                span = element("span");
                i = element("i");
                attr(i, "class", "fas fa-lg");
                toggle_class(i, "fa-moon", /*darkMode*/ ctx[9].active);
                toggle_class(i, "fa-sun", !/*darkMode*/ ctx[9].active);
                attr(span, "class", "icon is-medium has-text-grey-light");
                attr(a, "href", "javascript:void(0)");
                attr(a, "title", "Dark Mode");
                attr(a, "class", "navbar-link is-arrowless");
                attr(div, "class", "navbar-item has-dropdown is-hoverable");
                dispose = listen(a, "click", /*darkToggle*/ ctx[22]);
            },
            m(target, anchor) {
                insert(target, div, anchor);
                append(div, a);
                append(a, span);
                append(span, i);
            },
            p(ctx, dirty) {
                if (dirty[0] & /*darkMode*/ 512) {
                    toggle_class(i, "fa-moon", /*darkMode*/ ctx[9].active);
                }

                if (dirty[0] & /*darkMode*/ 512) {
                    toggle_class(i, "fa-sun", !/*darkMode*/ ctx[9].active);
                }
            },
            d(detaching) {
                if (detaching) detach(div);
                dispose();
            }
        };
    }

    // (563:8) {#if collapsed}
    function create_if_block_6$1(ctx) {
        let span;

        return {
            c() {
                span = element("span");
                span.textContent = "»";
                attr(span, "class", "icon");
                attr(span, "title", "Expand [");
            },
            m(target, anchor) {
                insert(target, span, anchor);
            },
            d(detaching) {
                if (detaching) detach(span);
            }
        };
    }

    // (566:8) {#if !collapsed}
    function create_if_block_5$1(ctx) {
        let span0;
        let t1;
        let span1;

        return {
            c() {
                span0 = element("span");
                span0.textContent = "«";
                t1 = space();
                span1 = element("span");
                span1.textContent = "Collapse sidebar";
                attr(span0, "class", "icon");
                attr(span1, "class", "fa-xs");
            },
            m(target, anchor) {
                insert(target, span0, anchor);
                insert(target, t1, anchor);
                insert(target, span1, anchor);
            },
            d(detaching) {
                if (detaching) detach(span0);
                if (detaching) detach(t1);
                if (detaching) detach(span1);
            }
        };
    }

    // (576:6) {#if index === -1}
    function create_if_block_4$1(ctx) {
        let div;
        let raw_value = markdown(/*description*/ ctx[1]) + "";

        return {
            c() {
                div = element("div");
                attr(div, "class", "content");
            },
            m(target, anchor) {
                insert(target, div, anchor);
                div.innerHTML = raw_value;
            },
            p(ctx, dirty) {
                if (dirty[0] & /*description*/ 2 && raw_value !== (raw_value = markdown(/*description*/ ctx[1]) + "")) div.innerHTML = raw_value;;
            },
            d(detaching) {
                if (detaching) detach(div);
            }
        };
    }

    // (582:6) {#if currentAction}
    function create_if_block$c(ctx) {
        let div2;
        let div0;
        let h1;
        let t0_value = /*currentAction*/ ctx[10].title + "";
        let t0;
        let t1;
        let div1;
        let nav;
        let ul;
        let t2;
        let hr;
        let t3;
        let div3;
        let code0;
        let t4_value = /*currentAction*/ ctx[10].method + "";
        let t4;
        let code0_class_value;
        let t5;
        let code1;
        let t6_value = /*currentAction*/ ctx[10].pathTemplate + "";
        let t6;
        let t7;
        let div4;
        let raw_value = markdown(/*currentAction*/ ctx[10].description) + "";
        let t8;
        let t9;
        let t10;
        let each1_anchor;
        let current;
        let each_value_1 = /*currentAction*/ ctx[10].tags;
        let each_blocks_1 = [];

        for (let i = 0; i < each_value_1.length; i += 1) {
            each_blocks_1[i] = create_each_block_1$3(get_each_context_1$3(ctx, each_value_1, i));
        }

        let if_block = /*config*/ ctx[4].playground.enabled && create_if_block_1$9(ctx);

        const parameterpanel = new ParameterPanel({
            props: {
                parameters: /*currentAction*/ ctx[10].parameters
            }
        });

        let each_value = /*transformedAction*/ ctx[11].groupedTransactions;
        let each_blocks = [];

        for (let i = 0; i < each_value.length; i += 1) {
            each_blocks[i] = create_each_block$7(get_each_context$7(ctx, each_value, i));
        }

        const out = i => transition_out(each_blocks[i], 1, 1, () => {
            each_blocks[i] = null;
        });

        return {
            c() {
                div2 = element("div");
                div0 = element("div");
                h1 = element("h1");
                t0 = text(t0_value);
                t1 = space();
                div1 = element("div");
                nav = element("nav");
                ul = element("ul");

                for (let i = 0; i < each_blocks_1.length; i += 1) {
                    each_blocks_1[i].c();
                }

                t2 = space();
                hr = element("hr");
                t3 = space();
                div3 = element("div");
                code0 = element("code");
                t4 = text(t4_value);
                t5 = space();
                code1 = element("code");
                t6 = text(t6_value);
                t7 = space();
                div4 = element("div");
                t8 = space();
                if (if_block) if_block.c();
                t9 = space();
                create_component(parameterpanel.$$.fragment);
                t10 = space();

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].c();
                }

                each1_anchor = empty();
                attr(h1, "class", "title is-4");
                attr(div0, "class", "column");
                attr(nav, "class", "breadcrumb breadcrumb-right is-pulled-right svelte-1jcck2f");
                attr(nav, "aria-label", "breadcrumbs");
                attr(div1, "class", "column");
                attr(div2, "class", "columns");
                attr(code0, "class", code0_class_value = "tag is-uppercase " + colorize(/*currentAction*/ ctx[10].method) + " svelte-1jcck2f");
                attr(code1, "class", "tag ");
                attr(div3, "class", "tags has-addons are-large");
                attr(div4, "class", "content");
            },
            m(target, anchor) {
                insert(target, div2, anchor);
                append(div2, div0);
                append(div0, h1);
                append(h1, t0);
                append(div2, t1);
                append(div2, div1);
                append(div1, nav);
                append(nav, ul);

                for (let i = 0; i < each_blocks_1.length; i += 1) {
                    each_blocks_1[i].m(ul, null);
                }

                insert(target, t2, anchor);
                insert(target, hr, anchor);
                insert(target, t3, anchor);
                insert(target, div3, anchor);
                append(div3, code0);
                append(code0, t4);
                append(div3, t5);
                append(div3, code1);
                append(code1, t6);
                insert(target, t7, anchor);
                insert(target, div4, anchor);
                div4.innerHTML = raw_value;
                insert(target, t8, anchor);
                if (if_block) if_block.m(target, anchor);
                insert(target, t9, anchor);
                mount_component(parameterpanel, target, anchor);
                insert(target, t10, anchor);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    each_blocks[i].m(target, anchor);
                }

                insert(target, each1_anchor, anchor);
                current = true;
            },
            p(ctx, dirty) {
                if ((!current || dirty[0] & /*currentAction*/ 1024) && t0_value !== (t0_value = /*currentAction*/ ctx[10].title + "")) set_data(t0, t0_value);

                if (dirty[0] & /*currentAction, handleGroupClick*/ 132096) {
                    each_value_1 = /*currentAction*/ ctx[10].tags;
                    let i;

                    for (i = 0; i < each_value_1.length; i += 1) {
                        const child_ctx = get_each_context_1$3(ctx, each_value_1, i);

                        if (each_blocks_1[i]) {
                            each_blocks_1[i].p(child_ctx, dirty);
                        } else {
                            each_blocks_1[i] = create_each_block_1$3(child_ctx);
                            each_blocks_1[i].c();
                            each_blocks_1[i].m(ul, null);
                        }
                    }

                    for (; i < each_blocks_1.length; i += 1) {
                        each_blocks_1[i].d(1);
                    }

                    each_blocks_1.length = each_value_1.length;
                }

                if ((!current || dirty[0] & /*currentAction*/ 1024) && t4_value !== (t4_value = /*currentAction*/ ctx[10].method + "")) set_data(t4, t4_value);

                if (!current || dirty[0] & /*currentAction*/ 1024 && code0_class_value !== (code0_class_value = "tag is-uppercase " + colorize(/*currentAction*/ ctx[10].method) + " svelte-1jcck2f")) {
                    attr(code0, "class", code0_class_value);
                }

                if ((!current || dirty[0] & /*currentAction*/ 1024) && t6_value !== (t6_value = /*currentAction*/ ctx[10].pathTemplate + "")) set_data(t6, t6_value);
                if ((!current || dirty[0] & /*currentAction*/ 1024) && raw_value !== (raw_value = markdown(/*currentAction*/ ctx[10].description) + "")) div4.innerHTML = raw_value;;

                if (/*config*/ ctx[4].playground.enabled) {
                    if (if_block) {
                        if_block.p(ctx, dirty);
                        transition_in(if_block, 1);
                    } else {
                        if_block = create_if_block_1$9(ctx);
                        if_block.c();
                        transition_in(if_block, 1);
                        if_block.m(t9.parentNode, t9);
                    }
                } else if (if_block) {
                    group_outros();

                    transition_out(if_block, 1, 1, () => {
                        if_block = null;
                    });

                    check_outros();
                }

                const parameterpanel_changes = {};
                if (dirty[0] & /*currentAction*/ 1024) parameterpanel_changes.parameters = /*currentAction*/ ctx[10].parameters;
                parameterpanel.$set(parameterpanel_changes);

                if (dirty[0] & /*darkMode, transformedAction*/ 2560) {
                    each_value = /*transformedAction*/ ctx[11].groupedTransactions;
                    let i;

                    for (i = 0; i < each_value.length; i += 1) {
                        const child_ctx = get_each_context$7(ctx, each_value, i);

                        if (each_blocks[i]) {
                            each_blocks[i].p(child_ctx, dirty);
                            transition_in(each_blocks[i], 1);
                        } else {
                            each_blocks[i] = create_each_block$7(child_ctx);
                            each_blocks[i].c();
                            transition_in(each_blocks[i], 1);
                            each_blocks[i].m(each1_anchor.parentNode, each1_anchor);
                        }
                    }

                    group_outros();

                    for (i = each_value.length; i < each_blocks.length; i += 1) {
                        out(i);
                    }

                    check_outros();
                }
            },
            i(local) {
                if (current) return;
                transition_in(if_block);
                transition_in(parameterpanel.$$.fragment, local);

                for (let i = 0; i < each_value.length; i += 1) {
                    transition_in(each_blocks[i]);
                }

                current = true;
            },
            o(local) {
                transition_out(if_block);
                transition_out(parameterpanel.$$.fragment, local);
                each_blocks = each_blocks.filter(Boolean);

                for (let i = 0; i < each_blocks.length; i += 1) {
                    transition_out(each_blocks[i]);
                }

                current = false;
            },
            d(detaching) {
                if (detaching) detach(div2);
                destroy_each(each_blocks_1, detaching);
                if (detaching) detach(t2);
                if (detaching) detach(hr);
                if (detaching) detach(t3);
                if (detaching) detach(div3);
                if (detaching) detach(t7);
                if (detaching) detach(div4);
                if (detaching) detach(t8);
                if (if_block) if_block.d(detaching);
                if (detaching) detach(t9);
                destroy_component(parameterpanel, detaching);
                if (detaching) detach(t10);
                destroy_each(each_blocks, detaching);
                if (detaching) detach(each1_anchor);
            }
        };
    }

    // (596:20) {:else}
    function create_else_block$5(ctx) {
        let a;
        let t_value = /*tag*/ ctx[30] + "";
        let t;
        let a_data_slug_value;
        let a_href_value;
        let dispose;

        return {
            c() {
                a = element("a");
                t = text(t_value);
                attr(a, "data-slug", a_data_slug_value = slugify(/*tag*/ ctx[30]));
                attr(a, "href", a_href_value = "#/g~" + slugify(/*tag*/ ctx[30]));
                dispose = listen(a, "click", /*handleGroupClick*/ ctx[17]);
            },
            m(target, anchor) {
                insert(target, a, anchor);
                append(a, t);
            },
            p(ctx, dirty) {
                if (dirty[0] & /*currentAction*/ 1024 && t_value !== (t_value = /*tag*/ ctx[30] + "")) set_data(t, t_value);

                if (dirty[0] & /*currentAction*/ 1024 && a_data_slug_value !== (a_data_slug_value = slugify(/*tag*/ ctx[30]))) {
                    attr(a, "data-slug", a_data_slug_value);
                }

                if (dirty[0] & /*currentAction*/ 1024 && a_href_value !== (a_href_value = "#/g~" + slugify(/*tag*/ ctx[30]))) {
                    attr(a, "href", a_href_value);
                }
            },
            d(detaching) {
                if (detaching) detach(a);
                dispose();
            }
        };
    }

    // (594:20) {#if index === 0}
    function create_if_block_3$3(ctx) {
        let a;
        let t_value = /*tag*/ ctx[30] + "";
        let t;

        return {
            c() {
                a = element("a");
                t = text(t_value);
                attr(a, "href", "javascript:void(0)");
            },
            m(target, anchor) {
                insert(target, a, anchor);
                append(a, t);
            },
            p(ctx, dirty) {
                if (dirty[0] & /*currentAction*/ 1024 && t_value !== (t_value = /*tag*/ ctx[30] + "")) set_data(t, t_value);
            },
            d(detaching) {
                if (detaching) detach(a);
            }
        };
    }

    // (592:16) {#each currentAction.tags as tag, index}
    function create_each_block_1$3(ctx) {
        let li;
        let t;

        function select_block_type(ctx, dirty) {
            if (/*index*/ ctx[13] === 0) return create_if_block_3$3;
            return create_else_block$5;
        }

        let current_block_type = select_block_type(ctx, -1);
        let if_block = current_block_type(ctx);

        return {
            c() {
                li = element("li");
                if_block.c();
                t = space();
            },
            m(target, anchor) {
                insert(target, li, anchor);
                if_block.m(li, null);
                append(li, t);
            },
            p(ctx, dirty) {
                if_block.p(ctx, dirty);
            },
            d(detaching) {
                if (detaching) detach(li);
                if_block.d();
            }
        };
    }

    // (624:8) {#if config.playground.enabled}
    function create_if_block_1$9(ctx) {
        let if_block_anchor;
        let current;
        let if_block = /*environment*/ ctx[12].playground !== false && create_if_block_2$5(ctx);

        return {
            c() {
                if (if_block) if_block.c();
                if_block_anchor = empty();
            },
            m(target, anchor) {
                if (if_block) if_block.m(target, anchor);
                insert(target, if_block_anchor, anchor);
                current = true;
            },
            p(ctx, dirty) {
                if (/*environment*/ ctx[12].playground !== false) {
                    if (if_block) {
                        if_block.p(ctx, dirty);
                        transition_in(if_block, 1);
                    } else {
                        if_block = create_if_block_2$5(ctx);
                        if_block.c();
                        transition_in(if_block, 1);
                        if_block.m(if_block_anchor.parentNode, if_block_anchor);
                    }
                } else if (if_block) {
                    group_outros();

                    transition_out(if_block, 1, 1, () => {
                        if_block = null;
                    });

                    check_outros();
                }
            },
            i(local) {
                if (current) return;
                transition_in(if_block);
                current = true;
            },
            o(local) {
                transition_out(if_block);
                current = false;
            },
            d(detaching) {
                if (if_block) if_block.d(detaching);
                if (detaching) detach(if_block_anchor);
            }
        };
    }

    // (625:10) {#if environment.playground !== false}
    function create_if_block_2$5(ctx) {
        let current;

        const playgroundpanel = new PlaygroundPanel({
            props: {
                currentAction: /*currentAction*/ ctx[10],
                pkceChallenge: /*challengePair*/ ctx[14],
                environments: /*config*/ ctx[4].playground.environments,
                requestHeaders: headersMap(/*currentAction*/ ctx[10]),
                requestParameters: parametersMap(/*currentAction*/ ctx[10]),
                requestBody: bodyMap(/*currentAction*/ ctx[10]),
                isDarkmode: /*darkMode*/ ctx[9].active
            }
        });

        return {
            c() {
                create_component(playgroundpanel.$$.fragment);
            },
            m(target, anchor) {
                mount_component(playgroundpanel, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const playgroundpanel_changes = {};
                if (dirty[0] & /*currentAction*/ 1024) playgroundpanel_changes.currentAction = /*currentAction*/ ctx[10];
                if (dirty[0] & /*config*/ 16) playgroundpanel_changes.environments = /*config*/ ctx[4].playground.environments;
                if (dirty[0] & /*currentAction*/ 1024) playgroundpanel_changes.requestHeaders = headersMap(/*currentAction*/ ctx[10]);
                if (dirty[0] & /*currentAction*/ 1024) playgroundpanel_changes.requestParameters = parametersMap(/*currentAction*/ ctx[10]);
                if (dirty[0] & /*currentAction*/ 1024) playgroundpanel_changes.requestBody = bodyMap(/*currentAction*/ ctx[10]);
                if (dirty[0] & /*darkMode*/ 512) playgroundpanel_changes.isDarkmode = /*darkMode*/ ctx[9].active;
                playgroundpanel.$set(playgroundpanel_changes);
            },
            i(local) {
                if (current) return;
                transition_in(playgroundpanel.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(playgroundpanel.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(playgroundpanel, detaching);
            }
        };
    }

    // (639:8) {#each transformedAction.groupedTransactions as { request, responses }
    function create_each_block$7(ctx) {
        let current;

        const scenariopanel = new ScenarioPanel({
            props: {
                show: /*index*/ ctx[13] === 0,
                isDarkmode: /*darkMode*/ ctx[9].active,
                request: /*request*/ ctx[27],
                responses: /*responses*/ ctx[28],
                index: /*index*/ ctx[13],
                count: /*transformedAction*/ ctx[11].groupedTransactions.length
            }
        });

        return {
            c() {
                create_component(scenariopanel.$$.fragment);
            },
            m(target, anchor) {
                mount_component(scenariopanel, target, anchor);
                current = true;
            },
            p(ctx, dirty) {
                const scenariopanel_changes = {};
                if (dirty[0] & /*darkMode*/ 512) scenariopanel_changes.isDarkmode = /*darkMode*/ ctx[9].active;
                if (dirty[0] & /*transformedAction*/ 2048) scenariopanel_changes.request = /*request*/ ctx[27];
                if (dirty[0] & /*transformedAction*/ 2048) scenariopanel_changes.responses = /*responses*/ ctx[28];
                if (dirty[0] & /*transformedAction*/ 2048) scenariopanel_changes.count = /*transformedAction*/ ctx[11].groupedTransactions.length;
                scenariopanel.$set(scenariopanel_changes);
            },
            i(local) {
                if (current) return;
                transition_in(scenariopanel.$$.fragment, local);
                current = true;
            },
            o(local) {
                transition_out(scenariopanel.$$.fragment, local);
                current = false;
            },
            d(detaching) {
                destroy_component(scenariopanel, detaching);
            }
        };
    }

    function create_fragment$i(ctx) {
        let div8;
        let nav;
        let div0;
        let a0;
        let span0;
        let t0;
        let span1;
        let t1;
        let t2;
        let a1;
        let t5;
        let div2;
        let div1;
        let t6;
        let t7;
        let div6;
        let div4;
        let t8;
        let div3;
        let t9;
        let t10;
        let div5;
        let t11;
        let t12;
        let footer;
        let div7;
        let p;
        let strong0;
        let t13;
        let t14;
        let a2;
        let current;
        let dispose;
        let if_block0 = /*config*/ ctx[4].playground.enabled && create_if_block_8$1(ctx);
        let if_block1 = /*darkMode*/ ctx[9].enable && create_if_block_7$1(ctx);

        const menupanel = new MenuPanel({
            props: {
                title: /*title*/ ctx[0],
                tagActions: /*tagActions*/ ctx[3],
                tagHeaders: toc(/*description*/ ctx[1]),
                currentSlug: /*currentAction*/ ctx[10] && /*currentAction*/ ctx[10].slug,
                actionsCount: /*actions*/ ctx[2].length,
                isCollapsed: /*collapsed*/ ctx[6],
                isDarkmode: /*darkMode*/ ctx[9].active,
                query: /*query*/ ctx[8],
                config: /*config*/ ctx[4],
                handleClick: /*handleClick*/ ctx[15],
                handleGroupClick: /*handleGroupClick*/ ctx[17],
                handleTagClick: /*handleTagClick*/ ctx[16],
                tocClick: /*tocClick*/ ctx[18],
                searchClick: /*searchClick*/ ctx[21]
            }
        });

        let if_block2 = /*collapsed*/ ctx[6] && create_if_block_6$1(ctx);
        let if_block3 = !/*collapsed*/ ctx[6] && create_if_block_5$1(ctx);
        let if_block4 = /*index*/ ctx[13] === -1 && create_if_block_4$1(ctx);
        let if_block5 = /*currentAction*/ ctx[10] && create_if_block$c(ctx);

        return {
            c() {
                div8 = element("div");
                nav = element("nav");
                div0 = element("div");
                a0 = element("a");
                span0 = element("span");
                span0.innerHTML = `<i class="fas fa-lg fa-chalkboard"></i>`;
                t0 = space();
                span1 = element("span");
                t1 = text(/*title*/ ctx[0]);
                t2 = space();
                a1 = element("a");

                a1.innerHTML = `<span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>`;

                t5 = space();
                div2 = element("div");
                div1 = element("div");
                if (if_block0) if_block0.c();
                t6 = space();
                if (if_block1) if_block1.c();
                t7 = space();
                div6 = element("div");
                div4 = element("div");
                create_component(menupanel.$$.fragment);
                t8 = space();
                div3 = element("div");
                if (if_block2) if_block2.c();
                t9 = space();
                if (if_block3) if_block3.c();
                t10 = space();
                div5 = element("div");
                if (if_block4) if_block4.c();
                t11 = space();
                if (if_block5) if_block5.c();
                t12 = space();
                footer = element("footer");
                div7 = element("div");
                p = element("p");
                strong0 = element("strong");
                t13 = text(/*title*/ ctx[0]);
                t14 = text("\n        powered by\n        ");
                a2 = element("a");
                a2.innerHTML = `<strong>Snowboard.</strong>`;
                attr(span0, "class", "icon icon-brand is-medium has-text-grey-light svelte-1jcck2f");
                attr(span1, "class", "title is-4");
                attr(a0, "href", "javascript:void(0)");
                attr(a0, "class", "navbar-item");
                attr(a1, "href", "javascript:void(0)");
                attr(a1, "role", "button");
                attr(a1, "class", "navbar-burger");
                attr(a1, "aria-label", "menu");
                attr(a1, "aria-expanded", "false");
                attr(a1, "data-target", "mainnav");
                attr(div0, "class", "navbar-brand");
                attr(div1, "class", "navbar-end");
                attr(div2, "class", "navbar-menu");
                attr(nav, "class", "navbar is-fixed-top has-shadow");
                attr(nav, "role", "navigation");
                attr(nav, "aria-label", "main navigation");
                attr(div3, "class", "menu-collapsible svelte-1jcck2f");
                toggle_class(div3, "is-darkmode", /*darkMode*/ ctx[9].active);
                attr(div4, "class", "column is-one-quarter sidenav svelte-1jcck2f");
                attr(div4, "id", "mainnav");
                toggle_class(div4, "is-hidden-mobile", /*showMenu*/ ctx[5]);
                attr(div5, "class", "column is-three-quarters main svelte-1jcck2f");
                toggle_class(div5, "is-darkmode", /*darkMode*/ ctx[9].active);
                attr(div6, "class", "columns svelte-1jcck2f");
                toggle_class(div6, "is-collapsed", /*collapsed*/ ctx[6]);
                attr(a2, "href", "https://github.com/bukalapak/snowboard");
                attr(a2, "target", "_blank");
                attr(div7, "class", "content column is-paddingless has-text-centered svelte-1jcck2f");
                toggle_class(div7, "is-offset-one-quarter", !/*collapsed*/ ctx[6]);
                attr(footer, "class", "footer svelte-1jcck2f");
                toggle_class(footer, "is-darkmode", /*darkMode*/ ctx[9].active);
                attr(div8, "class", "body-inner svelte-1jcck2f");
                toggle_class(div8, "is-darkmode", /*darkMode*/ ctx[9].active);

                dispose = [
                    listen(a1, "click", /*burgerClick*/ ctx[19]),
                    listen(div3, "click", /*collapseToggle*/ ctx[20])
                ];
            },
            m(target, anchor) {
                insert(target, div8, anchor);
                append(div8, nav);
                append(nav, div0);
                append(div0, a0);
                append(a0, span0);
                append(a0, t0);
                append(a0, span1);
                append(span1, t1);
                append(div0, t2);
                append(div0, a1);
                append(nav, t5);
                append(nav, div2);
                append(div2, div1);
                if (if_block0) if_block0.m(div1, null);
                append(div1, t6);
                if (if_block1) if_block1.m(div1, null);
                append(div8, t7);
                append(div8, div6);
                append(div6, div4);
                mount_component(menupanel, div4, null);
                append(div4, t8);
                append(div4, div3);
                if (if_block2) if_block2.m(div3, null);
                append(div3, t9);
                if (if_block3) if_block3.m(div3, null);
                append(div6, t10);
                append(div6, div5);
                if (if_block4) if_block4.m(div5, null);
                append(div5, t11);
                if (if_block5) if_block5.m(div5, null);
                append(div8, t12);
                append(div8, footer);
                append(footer, div7);
                append(div7, p);
                append(p, strong0);
                append(strong0, t13);
                append(p, t14);
                append(p, a2);
                current = true;
            },
            p(ctx, dirty) {
                if (!current || dirty[0] & /*title*/ 1) set_data(t1, /*title*/ ctx[0]);

                if (/*config*/ ctx[4].playground.enabled) {
                    if (if_block0) {
                        if_block0.p(ctx, dirty);
                        transition_in(if_block0, 1);
                    } else {
                        if_block0 = create_if_block_8$1(ctx);
                        if_block0.c();
                        transition_in(if_block0, 1);
                        if_block0.m(div1, t6);
                    }
                } else if (if_block0) {
                    group_outros();

                    transition_out(if_block0, 1, 1, () => {
                        if_block0 = null;
                    });

                    check_outros();
                }

                if (/*darkMode*/ ctx[9].enable) {
                    if (if_block1) {
                        if_block1.p(ctx, dirty);
                    } else {
                        if_block1 = create_if_block_7$1(ctx);
                        if_block1.c();
                        if_block1.m(div1, null);
                    }
                } else if (if_block1) {
                    if_block1.d(1);
                    if_block1 = null;
                }

                const menupanel_changes = {};
                if (dirty[0] & /*title*/ 1) menupanel_changes.title = /*title*/ ctx[0];
                if (dirty[0] & /*tagActions*/ 8) menupanel_changes.tagActions = /*tagActions*/ ctx[3];
                if (dirty[0] & /*description*/ 2) menupanel_changes.tagHeaders = toc(/*description*/ ctx[1]);
                if (dirty[0] & /*currentAction*/ 1024) menupanel_changes.currentSlug = /*currentAction*/ ctx[10] && /*currentAction*/ ctx[10].slug;
                if (dirty[0] & /*actions*/ 4) menupanel_changes.actionsCount = /*actions*/ ctx[2].length;
                if (dirty[0] & /*collapsed*/ 64) menupanel_changes.isCollapsed = /*collapsed*/ ctx[6];
                if (dirty[0] & /*darkMode*/ 512) menupanel_changes.isDarkmode = /*darkMode*/ ctx[9].active;
                if (dirty[0] & /*query*/ 256) menupanel_changes.query = /*query*/ ctx[8];
                if (dirty[0] & /*config*/ 16) menupanel_changes.config = /*config*/ ctx[4];
                menupanel.$set(menupanel_changes);

                if (/*collapsed*/ ctx[6]) {
                    if (!if_block2) {
                        if_block2 = create_if_block_6$1(ctx);
                        if_block2.c();
                        if_block2.m(div3, t9);
                    } else {

                    }
                } else if (if_block2) {
                    if_block2.d(1);
                    if_block2 = null;
                }

                if (!/*collapsed*/ ctx[6]) {
                    if (!if_block3) {
                        if_block3 = create_if_block_5$1(ctx);
                        if_block3.c();
                        if_block3.m(div3, null);
                    } else {

                    }
                } else if (if_block3) {
                    if_block3.d(1);
                    if_block3 = null;
                }

                if (dirty[0] & /*darkMode*/ 512) {
                    toggle_class(div3, "is-darkmode", /*darkMode*/ ctx[9].active);
                }

                if (dirty[0] & /*showMenu*/ 32) {
                    toggle_class(div4, "is-hidden-mobile", /*showMenu*/ ctx[5]);
                }

                if (/*index*/ ctx[13] === -1) {
                    if (if_block4) {
                        if_block4.p(ctx, dirty);
                    } else {
                        if_block4 = create_if_block_4$1(ctx);
                        if_block4.c();
                        if_block4.m(div5, t11);
                    }
                } else if (if_block4) {
                    if_block4.d(1);
                    if_block4 = null;
                }

                if (/*currentAction*/ ctx[10]) {
                    if (if_block5) {
                        if_block5.p(ctx, dirty);
                        transition_in(if_block5, 1);
                    } else {
                        if_block5 = create_if_block$c(ctx);
                        if_block5.c();
                        transition_in(if_block5, 1);
                        if_block5.m(div5, null);
                    }
                } else if (if_block5) {
                    group_outros();

                    transition_out(if_block5, 1, 1, () => {
                        if_block5 = null;
                    });

                    check_outros();
                }

                if (dirty[0] & /*darkMode*/ 512) {
                    toggle_class(div5, "is-darkmode", /*darkMode*/ ctx[9].active);
                }

                if (dirty[0] & /*collapsed*/ 64) {
                    toggle_class(div6, "is-collapsed", /*collapsed*/ ctx[6]);
                }

                if (!current || dirty[0] & /*title*/ 1) set_data(t13, /*title*/ ctx[0]);

                if (dirty[0] & /*collapsed*/ 64) {
                    toggle_class(div7, "is-offset-one-quarter", !/*collapsed*/ ctx[6]);
                }

                if (dirty[0] & /*darkMode*/ 512) {
                    toggle_class(footer, "is-darkmode", /*darkMode*/ ctx[9].active);
                }

                if (dirty[0] & /*darkMode*/ 512) {
                    toggle_class(div8, "is-darkmode", /*darkMode*/ ctx[9].active);
                }
            },
            i(local) {
                if (current) return;
                transition_in(if_block0);
                transition_in(menupanel.$$.fragment, local);
                transition_in(if_block5);
                current = true;
            },
            o(local) {
                transition_out(if_block0);
                transition_out(menupanel.$$.fragment, local);
                transition_out(if_block5);
                current = false;
            },
            d(detaching) {
                if (detaching) detach(div8);
                if (if_block0) if_block0.d();
                if (if_block1) if_block1.d();
                destroy_component(menupanel);
                if (if_block2) if_block2.d();
                if (if_block3) if_block3.d();
                if (if_block4) if_block4.d();
                if (if_block5) if_block5.d();
                run_all(dispose);
            }
        };
    }

    function sample(action) {
        return action.transactions[0].request;
    }

    function headersMap(action) {
        return sample(action).headers.filter(header => header.name != "Authorization").map(header => {
            return {
                used: true,
                required: false,
                name: header.name,
                value: header.example || ""
            };
        });
    }

    function parametersMap(action) {
        return action.parameters.map(param => {
            return {
                used: param.required,
                required: param.required,
                name: param.name,
                value: param.example || ""
            };
        });
    }

    function bodyMap(action) {
        const example = sample(action).example;
        return stringify$2(example);
    }

    function instance$i($$self, $$props, $$invalidate) {
        let $env;
        component_subscribe($$self, env, $$value => $$invalidate(24, $env = $$value));
        let { title } = $$props;
        let { description } = $$props;
        let { actions } = $$props;
        let { tagActions } = $$props;
        let { config } = $$props;
        let index = -1;
        let challengePair = pkce.create();

        function handleClick(event) {
            let target = event.target;

            if (target.nodeName == "SPAN") {
                target = target.parentElement;
            }

            const slug = target.dataset["slug"];
            $$invalidate(13, index = actions.findIndex(el => el.slug === slug));
            document.body.scrollTop = document.documentElement.scrollTop = 0;
        }

        function handleTagClick(event) {
            const tagSlug = event.target.dataset["slug"];
            const firstGroup = firstTagGroup(tagSlug);

            if (firstGroup) {
                const firstAction = firstGroupAction(slugify(firstGroup.title));
                const slug = firstAction.slug;
                $$invalidate(13, index = actions.findIndex(el => el.slug === slug));
                $$invalidate(8, query = `rg:${tagSlug}`);
                document.body.scrollTop = document.documentElement.scrollTop = 0;
            }
        }

        function firstTagGroup(tagSlug) {
            let matches = [];

            tagActions.forEach(tag => {
                if (slugify(tag.title) === tagSlug) {
                    matches.push(tag);
                }
            });

            if (matches.length > 0) {
                return matches[0].children[0];
            }
        }

        function handleGroupClick(event) {
            const groupSlug = event.target.dataset["slug"];
            const firstAction = firstGroupAction(groupSlug);

            if (firstAction) {
                const slug = firstAction.slug;
                $$invalidate(13, index = actions.findIndex(el => el.slug === slug));
                $$invalidate(8, query = `g:${groupSlug}`);
                document.body.scrollTop = document.documentElement.scrollTop = 0;
            }
        }

        function firstGroupAction(groupSlug) {
            let matches = [];

            tagActions.forEach(tag => {
                matches = matches.concat(tag.children.filter(child => slugify(child.title) === groupSlug));
            });

            if (matches.length > 0) {
                return matches[0].actions[0];
            }
        }

        function tocClick(event) {
            $$invalidate(13, index = -1);
            let href = event.target.getAttribute("href");
            pushHistory(href);
        }

        if (config.playground.enabled) {
            const savedEnv = getEnv();

            if (savedEnv && Object.keys(config.playground.environments).includes(savedEnv)) {
                env.set(savedEnv);
            } else {
                env.set(config.playground.env);
            }

            const authToken = getToken($env);

            if (authToken) {
                auth.add($env);
                token.set(authToken);
            }
        }

        let showMenu = true;
        let collapsed = false;
        let authenticating = false;
        let query = "";

        function burgerClick() {
            $$invalidate(5, showMenu = !showMenu);
        }

        function collapseToggle() {
            $$invalidate(6, collapsed = !collapsed);
        }

        function searchClick() {
            collapseToggle();
            const searchInput = document.getElementById("search-input-text");

            if (searchInput) {
                searchInput.focus();
            }
        }

        const darkMode = {
            enable: true,
            store: window.localStorage,
            toggle: "darkmode-toggle",
            mode: ["light", "dark"],
            active: false
        };

        function darkToggle() {
            $$invalidate(9, darkMode.active = !darkMode.active, darkMode);
            document.getElementById(`bulma-theme-${darkMode.mode[Number(!darkMode.active)]}`).media = "none";
            document.getElementById(`bulma-theme-${darkMode.mode[Number(darkMode.active)]}`).media = "";
            darkMode.store.setItem(darkMode.toggle, darkMode.mode[Number(darkMode.active)]);
        }

        if (darkMode.store.getItem(darkMode.toggle) === darkMode.mode[1]) {
            darkToggle();
        }

        onMount(async () => {
            if (isAuth(environment, "oauth2") || isAuth(environment, "oauth2-pkce")) {
                const authParam = querystringify_1.parse(location.search);

                if (authParam.code) {
                    $$invalidate(7, authenticating = true);
                    pushHistory(basePath(config));
                    const { accessToken, refreshToken } = await exchangeToken(authParam.code, environment.auth.options, isAuth(environment, "oauth2-pkce"), challengePair);

                    if (accessToken) {
                        setToken($env, accessToken);
                        auth.add($env);
                        token.set(accessToken);

                        if (refreshToken) {
                            setRefreshToken($env, refreshToken);
                        }
                    }

                    $$invalidate(7, authenticating = false);
                }
            }

            const hash = location.hash;

            if (hash.match("#/")) {
                let slug = hash.replace("#/", "");

                if (slug.startsWith("g~")) {
                    const groupSlug = slug.substr(2);
                    const firstAction = firstGroupAction(groupSlug);

                    if (firstAction) {
                        slug = firstAction.slug;
                        $$invalidate(8, query = `g:${groupSlug}`);
                    }
                }

                if (slug.startsWith("rg~")) {
                    const tagSlug = slug.substr(3);
                    const firstGroup = firstTagGroup(tagSlug);

                    if (firstGroup) {
                        const firstAction = firstGroupAction(slugify(firstGroup.title));

                        if (firstAction) {
                            slug = firstAction.slug;
                            $$invalidate(8, query = `rg:${tagSlug}`);
                        }
                    }
                }

                $$invalidate(13, index = actions.findIndex(el => el.slug === slug));
            }
        });

        document.onkeyup = function (e) {
            if ((e.which || e.keyCode) == 219) {
                collapseToggle();
            }
        };

        $$self.$set = $$props => {
            if ("title" in $$props) $$invalidate(0, title = $$props.title);
            if ("description" in $$props) $$invalidate(1, description = $$props.description);
            if ("actions" in $$props) $$invalidate(2, actions = $$props.actions);
            if ("tagActions" in $$props) $$invalidate(3, tagActions = $$props.tagActions);
            if ("config" in $$props) $$invalidate(4, config = $$props.config);
        };

        let groupTransactionsFunc;
        let transformedAction;
        let currentAction;
        let environment;

        $$self.$$.update = () => {
            if ($$self.$$.dirty[0] & /*actions, index*/ 8196) {
                $$invalidate(10, currentAction = actions[index]);
            }

            if ($$self.$$.dirty[0] & /*currentAction, title*/ 1025) {
                {
                    document.title = currentAction && `${currentAction.title} - ${title}` || title;
                }
            }

            if ($$self.$$.dirty[0] & /*groupTransactionsFunc, actions, index*/ 8396804) {
                $$invalidate(11, transformedAction = groupTransactionsFunc(actions[index]));
            }

            if ($$self.$$.dirty[0] & /*config, $env*/ 16777232) {
                $$invalidate(12, environment = config.playground.enabled && config.playground.environments[$env]);
            }
        };

        $$invalidate(23, groupTransactionsFunc = action => {
            if (typeof action === "undefined") {
                return undefined;
            }

            let data = Object.assign({}, action);
            data.groupedTransactions = [];

            data.transactions.forEach(transaction => {
                let title = transaction.request.title;
                let foundIndex = null;

                data.groupedTransactions.forEach((transaction, index) => {
                    if (foundIndex === null && transaction.request.title === title) {
                        foundIndex = index;
                    }
                });

                if (foundIndex === null) {
                    data.groupedTransactions.push({
                        request: transaction.request,
                        responses: [transaction.response]
                    });
                } else {
                    data.groupedTransactions[foundIndex].responses.push(transaction.response);
                }
            });

            return data;
        });

        return [
            title,
            description,
            actions,
            tagActions,
            config,
            showMenu,
            collapsed,
            authenticating,
            query,
            darkMode,
            currentAction,
            transformedAction,
            environment,
            index,
            challengePair,
            handleClick,
            handleTagClick,
            handleGroupClick,
            tocClick,
            burgerClick,
            collapseToggle,
            searchClick,
            darkToggle
        ];
    }

    class Winter extends SvelteComponent {
        constructor(options) {
            super();
            if (!document_1.getElementById("svelte-1jcck2f-style")) add_css$9();

            init(
                this,
                options,
                instance$i,
                create_fragment$i,
                safe_not_equal,
                {
                    title: 0,
                    description: 1,
                    actions: 2,
                    tagActions: 3,
                    config: 4
                },
                [-1, -1]
            );
        }
    }

    const app = new Winter({
        target: document.body,
        props: {{apisJsonData}}
    });

    return app;

}());
</script>
  </body>
</html>
