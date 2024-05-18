import { hash } from "./hash.mjs";

const caches = new Map();

export const init = (cacheNames) => {
  cacheNames.toArray().forEach((name) => {
    if (!caches.has(name)) {
      caches.set(name, new Map());
    }
  });
};

export const memo = (arg, cacheName, fun) => {
  const cache = getCache(cacheName);
  const key = hash(arg);
  const resp = cache.get(key);
  if (resp != null) {
    return resp;
  } else {
    const resp = fun(arg);
    cache.set(key, resp);
    return resp;
  }
};

export const invalidateAll = (cacheName) => {
  const cache = getCache(cacheName);
  cache.clear();
};

export const invalidateSpecific = (arg, cacheName) => {
  const cache = getCache(cacheName);
  cache.delete(hash(arg));
};

const getCache = (cacheName) => {
  const cache = caches.get(cacheName);
  if (!cache) {
    throw new Error(`Cache not initialized "${cacheName}"`);
  }
  return cache;
};

export const cleanUp = () => caches.clear();
