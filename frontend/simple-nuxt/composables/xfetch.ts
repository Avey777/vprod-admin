import type { UseFetchOptions } from "#app";
import { defu } from "defu";

export function xFetch<T>(
  url: string | (() => string),
  options: UseFetchOptions<T> = {},
) {
  const store = useMemberStore();
  const config = useRuntimeConfig();

  const defaults: UseFetchOptions<T> = {
    baseURL: config.baseUrl as string,
    key: url as string,
    headers: store.token
      ? {
          Authorization: `Bearer ${store.token}`,
          "Content-Type": "application/json",
          Cookie: "",
        }
      : {},

    onResponse(_ctx) {
      // _ctx.response._data = new myBusinessResponse(_ctx.response._data)
    },

    onResponseError(_ctx) {
      let errMessage = "";
      switch (_ctx.response.status) {
        case 401:
          errMessage =
            "The user does not have permission (token, user name, password error)!";
          store.logout();
          navigateTo("/member/login");
          break;
        case 404:
          errMessage = "Network request error, the resource was not found!";
          break;
        case 405:
          errMessage = "Network request error, request method not allowed!";
          break;
        case 408:
          errMessage = "Network request timed out!";
          break;
        case 500:
          errMessage = "Server error, please contact the administrator!";
          break;
        case 501:
          errMessage = "The network is not implemented!";
          break;
        case 502:
          errMessage = "Network Error!";
          break;
        case 503:
          errMessage =
            "The service is unavailable, the server is temporarily overloaded or maintained!";
          break;
        case 504:
          errMessage = "Network timeout!";
          break;
        case 505:
          errMessage = "The http version does not support the request!";
          break;
        default:
          errMessage = "Network Error!";
      }

      ElMessage({
        message: errMessage,
        type: "error",
      });
    },
  };

  const params = defu(options, defaults);

  return $fetch<T>(url as string, params);
}
